//
//  SignUpViewModel.swift
//  BookSNS
//
//  Created by 민지은 on 2024/04/11.
//

import Foundation
import RxSwift
import RxCocoa

class SignUpViewModel {
    
    var disposeBag = DisposeBag()
    
    struct Input {
        let idText: Observable<String>
        let passwordText: Observable<String>
        let nicknameText: Observable<String>
        let emailValidationButtonTapped: Observable<Void>
        let signUpButtonTapped: Observable<Void>
    }
    
    struct Output {
        let signUpValidation: Driver<Bool>
        let signUpSuccess: Driver<Void>
        let emailValidMessage: Driver<String>
    }
    
    func transfrom(input: Input) -> Output {
        
        let signUpObservable = Observable.combineLatest(input.idText, input.passwordText, input.nicknameText)
            .map { id, password, nickname in
                return SignUpQuery(email: id, password: password, nick: nickname)
            }
        
        let signUpSuccess = PublishRelay<Void>()
        let signUpValid = BehaviorRelay(value: false)
        var emailValid = false
        let emailValidMessage = PublishRelay<String>()
        
        input.emailValidationButtonTapped
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .withLatestFrom(signUpObservable)
            .flatMap { signUpQuery in
                return NetworkManager.APIcall(type: MessageModel.self, router: Router.emailValidation(query: EmailValidationQuery(email: signUpQuery.email)))
            }
            .subscribe(with: self) { owner, messageModel in
                emailValidMessage.accept(messageModel.message)
                if messageModel.message.contains("불가") {
                    emailValid = false
                } else {
                    emailValid = true
                }
            } onError: { owner, error in
                print("오류 발생")
                emailValid = false
            }
            .disposed(by: disposeBag)
        
        
        //signUp 유효성 검사
        signUpObservable.bind(with: self) { owner, signUp in
            if signUp.email.count > 5 && signUp.password.count > 8 && signUp.nick.count > 2 && emailValid {
                signUpValid.accept(true)
            } else {
                signUpValid.accept(false)
            }
        }
        .disposed(by: disposeBag)
        
        input.signUpButtonTapped
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .withLatestFrom(signUpObservable)
            .flatMap { signUpQuery in
                return NetworkManager.APIcall(type: SignUpModel.self, router: Router.signUp(query: signUpQuery))
            }
            .subscribe(with: self) { owner, loginModel in
                signUpSuccess.accept(())
            } onError: { owner, error in
                print("오류 발생")
            }
            .disposed(by: disposeBag)
        
        
        return Output(signUpValidation: signUpValid.asDriver(), signUpSuccess: signUpSuccess.asDriver(onErrorJustReturn: ()), emailValidMessage: emailValidMessage.asDriver(onErrorJustReturn: ""))
    }
    
}
