//
//  SignInViewModel.swift
//  BookSNS
//
//  Created by 민지은 on 2024/04/11.
//

import Foundation
import RxSwift
import RxCocoa
import UIKit

class SignInViewModel {
    
    var disposeBag = DisposeBag()
    
    struct Input {
        let emailText: Observable<String>
        let passwordText: Observable<String>
        let signInButtonTapped: Observable<Void>
    }
    
    struct Output {
        let signInValidation: Driver<Bool>
        let signInSuccess: Driver<Void>
    }
    
    func transform(input: Input) -> Output {
        
        let signInObservable = Observable.combineLatest(input.emailText, input.passwordText)
            .map { email, password in
                return SignInQuery(email: email, password: password)
            }
        
        
        let signInSuccess = PublishRelay<Void>()
        let signInValid = BehaviorRelay(value: false)
        
        let profileQuery = PublishSubject<ProfileQuery>()
        
        signInObservable
            .bind(with: self) { owner, signIn in
                if signIn.email.count > 5 && signIn.password.count >= 8 {
                    signInValid.accept(true)
                } else {
                    signInValid.accept(false)
                }
            }
            .disposed(by: disposeBag)
        
        input.signInButtonTapped
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .withLatestFrom(signInObservable)
            .flatMap { signInQuery in
                return NetworkManager.APIcall(type: SignInModel.self, router: Router.signIn(query: signInQuery))
                    .catch { error in
                        return Single<SignInModel>.never()
                    }
            }
            .subscribe(with: self) { owner, signInModel in
                signInSuccess.accept(())
                
                UserDefaults.standard.set(signInModel.user_id, forKey: "userID")
                UserDefaults.standard.set(signInModel.email, forKey: "email")
                UserDefaults.standard.set(signInModel.nick, forKey: "nick")
                UserDefaults.standard.set(signInModel.accessToken, forKey: "accessToken")
                UserDefaults.standard.set(signInModel.refreshToken, forKey: "refreshToken")
                
                if signInModel.profileImage.isEmpty {
                    profileQuery.onNext(ProfileQuery(nick: signInModel.nick, profile: (UIImage(named: "defaultProfile")?.pngData())!))
                } else {
                    UserDefaults.standard.set(signInModel.profileImage, forKey: "profileImage")
                }
                
                HomeViewModel.shared.updatePost.onNext(())
                SearchViewModel.shared.updatePost.onNext(())
                MarketHomeViewModel.shared.updatePost.onNext(())
    
            } onError: { owner, error in
                print("오류 발생")
            }
            .disposed(by: disposeBag)
        
        profileQuery
            .flatMap { profileQuery in
            return NetworkManager.uploadProfile(query: profileQuery)
        }
        .subscribe(with: self) { owner, profileModel in
            print(UserDefaultsInfo.profileImage ?? "프로필 사진 정보 없음")
            UserDefaults.standard.setValue(profileModel.profileImage, forKey: "profileImage")
            print(UserDefaultsInfo.profileImage ?? "프로필 사진 정보 없음")
        } onError: { owner, error in
            print("오류 발생 \(error)")
        }
        .disposed(by: disposeBag)
        
        
        
        
        return Output(signInValidation: signInValid.asDriver(), signInSuccess: signInSuccess.asDriver(onErrorJustReturn: ()))
    }
    
}
