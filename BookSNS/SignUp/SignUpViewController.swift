//
//  SignInViewController.swift
//  BookSNS
//
//  Created by 민지은 on 2024/04/11.
//

import UIKit
import RxSwift
import RxCocoa

class SignUpViewController: RxBaseViewController {

    let mainView = SignUpView()
    let viewModel = SignUpViewModel()
    
    override func loadView() {
        self.view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func bind() {
        let input = SignUpViewModel.Input(idText: mainView.emailTextField.rx.text.orEmpty.asObservable(), passwordText: BehaviorRelay(value: ""), nicknameText: BehaviorRelay(value: ""), emailValidationButtonTapped: mainView.emailValidationButton.rx.tap.asObservable(), signUpButtonTapped: mainView.signUpButton.rx.tap.asObservable())
        
        let output = viewModel.transfrom(input: input)
        
        mainView.nickNameTextField.rx.text.orEmpty
            .subscribe(with: self) { owner, nick in
                input.nicknameText.accept(nick)
            }
            .disposed(by: disposeBag)
        
        mainView.passwordTextField.rx.isSecureTextEntry.onNext(true)
        
        mainView.passwordTextField.rx.text.orEmpty
            .subscribe(with: self) { owner, password in
                input.passwordText.accept(password)
            }
            .disposed(by: disposeBag)


        output.signUpValidation
            .subscribe(with: self) { owner, valid in
                owner.mainView.signUpButton.isEnabled = valid
                owner.mainView.signUpButton.backgroundColor = valid ? Color.mainColor : Color.lightPoint
            }
            .disposed(by: disposeBag)
        
        output.idValidation
            .bind(to: mainView.emailLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.availableIdCheck
            .bind(with: self, onNext: { owner, value in
                owner.mainView.emailValidationButton.rx.isEnabled.onNext(value)
                owner.mainView.emailValidationButton.rx.backgroundColor.onNext(value ? Color.mainColor : Color.lightPoint)
            })
            .disposed(by: disposeBag)
        
        output.idValidationSuccesss
            .bind(with: self) { owner, value in
                if value {
                    owner.mainView.emailLabel.rx.textColor.onNext(Color.bluePoint)
                } else {
                    owner.mainView.emailLabel.rx.textColor.onNext(Color.redPoint)
                }
            }
            .disposed(by: disposeBag)
        
        output.passwordValidation
            .bind(to: mainView.passwordLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.passwordValidationSuccesss
            .bind(with: self) { owner, value in
                if value {
                    owner.mainView.passwordLabel.rx.textColor.onNext(Color.bluePoint)
                } else {
                    owner.mainView.passwordLabel.rx.textColor.onNext(Color.redPoint)
                }
            }
            .disposed(by: disposeBag)
        
        output.nickValidation
            .bind(to: mainView.nicknameLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.nickValidationSuccesss
            .bind(with: self) { owner, value in
                if value {
                    owner.mainView.nicknameLabel.rx.textColor.onNext(Color.bluePoint)
                } else {
                    owner.mainView.nicknameLabel.rx.textColor.onNext(Color.redPoint)
                }
            }
            .disposed(by: disposeBag)

        output.signUpSuccess
            .subscribe(with: self) { owner, value in
                if value {
                    print("회원가입 성공")
                    Transition.pop(owner)
                }
            }
            .disposed(by: disposeBag)
    }

}

