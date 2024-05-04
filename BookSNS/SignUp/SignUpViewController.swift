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
        let input = SignUpViewModel.Input(idText: mainView.emailTextField.rx.text.orEmpty.asObservable(), passwordText: mainView.passwordTextField.rx.text.orEmpty.asObservable(), nicknameText: mainView.nickNameTextField.rx.text.orEmpty.asObservable(), emailValidationButtonTapped: mainView.emailValidationButton.rx.tap.asObservable(), signUpButtonTapped: mainView.signUpButton.rx.tap.asObservable())
        
        let output = viewModel.transfrom(input: input)
        
        output.signUpValidation
            .drive(with: self) { owner, valid in
                owner.mainView.signUpButton.isEnabled = valid
                owner.mainView.signUpButton.backgroundColor = valid ? .blue : .red
            }
            .disposed(by: disposeBag)
        
        output.emailValidMessage
            .drive(with: self) { owner, message in
                let alert = UIAlertController(title: message, message: nil, preferredStyle: .alert)

                let button = UIAlertAction(title: "확인", style: .default)
                
                alert.addAction(button)
                self.present(alert, animated: true)
            }
            .disposed(by: disposeBag)
        
        output.signUpSuccess
            .drive(with: self) { owner, _ in
                print("회원가입 성공")
                owner.navigationController?.popViewController(animated: true)
            }
            .disposed(by: disposeBag)
    }

}

