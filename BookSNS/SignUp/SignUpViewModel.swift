//
//  SignUpViewModel.swift
//  BookSNS
//
//  Created by 민지은 on 2024/04/11.
//

import Foundation
import RxSwift
import RxCocoa

enum EmailValidation: String {
    case TypeMismatch = "이메일 형식으로 입력해주세요"
    case CheckDuplication = "이메일 중복 확인을 진행해주세요"
    case UnavailiableEmail = "이미 사용중인 이메일입니다"
    case AvailableEmail = "사용가능한 이메일입니다"
}

enum PasswordValidation: String {
    case TypeMismatch = "비밀번호는 8자 이상으로 입력해주세요"
    case AvailablePassword = "사용가능한 비밀번호입니다"
}

enum NickValidation: String {
    case TypeMismatch = "닉네임은 2자 이상으로 입력해주세요"
    case AvailableNick = "사용가능한 닉네임입니다"
}

class SignUpViewModel {
    
    var disposeBag = DisposeBag()

    struct Input {
        let idText: Observable<String>
        let passwordText: BehaviorRelay<String>
        let nicknameText: BehaviorRelay<String>
        let emailValidationButtonTapped: Observable<Void>
        let signUpButtonTapped: Observable<Void>
    }
    
    struct Output {
        let idValidation: PublishSubject<String>  //이메일 유효성 메시지
        let availableIdCheck: PublishSubject<Bool> //중복확인 가능 여부
        let idValidationSuccesss: BehaviorRelay<Bool> //이메일 사용 가능
        let signUpValidation: BehaviorRelay<Bool> //회원가입 가능 여부
        let passwordValidation: PublishSubject<String> //비밀번호 문구
        let passwordValidationSuccesss: BehaviorRelay<Bool> //비밀번호 사용 가능
        let nickValidation: PublishSubject<String> //닉네임 문구
        let nickValidationSuccesss: BehaviorRelay<Bool> //닉네임 사용 가능
        let signUpSuccess: PublishSubject<Bool> //회원가입 성공
    }
    
    func transfrom(input: Input) -> Output {
        
        let signUpObservable = Observable.combineLatest(input.idText, input.passwordText, input.nicknameText)
            .map { id, password, nickname in
                return SignUpQuery(email: id, password: password, nick: nickname)
            }

        var checkEmailValid = false
        var emailValid = false
        
        let idValidation = PublishSubject<String>() //이메일 유효성 메시지
        let availableIdCheck = PublishSubject<Bool>() //중복확인 가능 여부
        let idValidationSuccess = BehaviorRelay(value: false) //이메일 유효성 성공 여부
        let passwordValidation = PublishSubject<String>()
        let passwordValidationSuccess = BehaviorRelay(value: false) //비밀번호 유효성 성공 여부
        let nickValidation = PublishSubject<String>()
        let nickValidationSuccess = BehaviorRelay(value: false) //비밀번호 유효성 성공 여부
        
        let signUpCheck = PublishRelay<Void>()
        let signUpValidation = BehaviorRelay(value: false) //회원가입 가능 여부
        let signUpSuccess = PublishSubject<Bool>() //회원가입 성공 여부
        
        input.idText
            .subscribe(with: self) { owner, id in
                signUpCheck.accept(())
                    if id.contains("@") && id.contains(".") && id.count > 8 {
                        //중복확인 버튼 Enable 여부
                        availableIdCheck.onNext(true)
                        if !checkEmailValid {
                            //이메일 형식이 지켜졌지만, 중복확인을 안한 경우
                            idValidation.onNext(EmailValidation.CheckDuplication.rawValue)
                            idValidationSuccess.accept(false)
                        } else { //중복확인을 진행한 경우
                            if !emailValid {
                                //중복 이메일이 있을 경우
                                idValidation.onNext(EmailValidation.UnavailiableEmail.rawValue)
                                idValidationSuccess.accept(false)
                            } else {
                                idValidation.onNext(EmailValidation.AvailableEmail.rawValue)
                                idValidationSuccess.accept(true)
                            }
                        }
                    } else {
                        //이메일 형식을 지키지 못했을 경우
                        availableIdCheck.onNext(false)
                        idValidation.onNext(EmailValidation.TypeMismatch.rawValue)
                        idValidationSuccess.accept(false)
                        availableIdCheck.onNext(false)
                    }
            }
            .disposed(by: disposeBag)
        
        
        input.emailValidationButtonTapped
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .withLatestFrom(signUpObservable)
            .flatMap { signUpQuery in
                return NetworkManager.APIcall(type: MessageModel.self, router: Router.emailValidation(query: EmailValidationQuery(email: signUpQuery.email)))
                    .catch { error in
                        return Single<MessageModel>.never()
                    }
            }
            .subscribe(with: self) { owner, messageModel in
                checkEmailValid = true
                if messageModel.message.contains("불가") {
                    emailValid = false
                    idValidation.onNext(EmailValidation.UnavailiableEmail.rawValue)
                    idValidationSuccess.accept(false)
                } else {
                    emailValid = true
                    idValidation.onNext(EmailValidation.AvailableEmail.rawValue)
                    idValidationSuccess.accept(true)
                }
            } onError: { owner, error in
                print("오류 발생")
                emailValid = false
            }
            .disposed(by: disposeBag)
        
        input.passwordText.subscribe(with: self) { owner, password in
            signUpCheck.accept(())
            if password.count >= 8 {
                passwordValidation.onNext(PasswordValidation.AvailablePassword.rawValue)
                passwordValidationSuccess.accept(true)
            } else {
                passwordValidation.onNext(PasswordValidation.TypeMismatch.rawValue)
                passwordValidationSuccess.accept(false)
            }
        }
        .disposed(by: disposeBag)
        
        input.nicknameText.subscribe(with: self) { owner, nick in
            signUpCheck.accept(())
            if nick.count >= 2 {
                nickValidation.onNext(NickValidation.AvailableNick.rawValue)
                nickValidationSuccess.accept(true)
            } else {
                nickValidation.onNext(NickValidation.TypeMismatch.rawValue)
                nickValidationSuccess.accept(false)
            }
        }
        .disposed(by: disposeBag)
        
        signUpCheck.subscribe(with: self) { owner, _ in
            if (idValidationSuccess.value == true && input.passwordText.value.count >= 8) && input.nicknameText.value.count > 1 {
                signUpValidation.accept(true)
            } else {
                signUpValidation.accept(false)
            }
        }
        .disposed(by: disposeBag)

        input.signUpButtonTapped
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .withLatestFrom(signUpObservable)
            .flatMap { signUpQuery in
                return NetworkManager.APIcall(type: SignUpModel.self, router: Router.signUp(query: signUpQuery))
                    .catch { error in
                        return Single<SignUpModel>.never()
                    }
            }
            .subscribe(with: self) { owner, loginModel in
                print("회원가입 성공", loginModel)
                signUpSuccess.onNext(true)
            } onError: { owner, error in
                print("오류 발생")
                signUpSuccess.onNext(false)
            }
            .disposed(by: disposeBag)
        
        
        return Output(idValidation: idValidation, availableIdCheck: availableIdCheck, idValidationSuccesss: idValidationSuccess, signUpValidation: signUpValidation, passwordValidation: passwordValidation, passwordValidationSuccesss: passwordValidationSuccess, nickValidation: nickValidation, nickValidationSuccesss: nickValidationSuccess, signUpSuccess: signUpSuccess)
    }
    
}
