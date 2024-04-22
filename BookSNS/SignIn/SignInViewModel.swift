//
//  SignInViewModel.swift
//  BookSNS
//
//  Created by 민지은 on 2024/04/11.
//

import Foundation
import RxSwift
import RxCocoa

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
        
        signInObservable
            .bind(with: self) { owner, signIn in
                if signIn.email.count > 5 && signIn.password.count > 8 {
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
            }
            .subscribe(with: self) { owner, signInModel in
                signInSuccess.accept(())
                UserDefaults.standard.set(signInModel.user_id, forKey: "userID")
                UserDefaults.standard.set(signInModel.nick, forKey: "nick")
                UserDefaults.standard.set(signInModel.profileImage, forKey: "profileImage")
                UserDefaults.standard.set(signInModel.accessToken, forKey: "accessToken")
                UserDefaults.standard.set(signInModel.refreshToken, forKey: "refreshToken")
            } onError: { owner, error in
                print("오류 발생")
            }
            .disposed(by: disposeBag)
        
        
        
        return Output(signInValidation: signInValid.asDriver(), signInSuccess: signInSuccess.asDriver(onErrorJustReturn: ()))
    }
    
}
