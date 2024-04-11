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
        let input = SignUpViewModel.Input(idText: mainView.emailTextField.rx.text.orEmpty.asObservable(), passwordText: mainView.passwordTextField.rx.text.orEmpty.asObservable(), nicknameText: mainView.nickNameTextField.rx.text.orEmpty.asObservable(), signUpButtonTapped: mainView.signUpButton.rx.tap.asObservable())
        
        let output = viewModel.transfrom(input: input)
        
        output.signUpValidation
            .drive(with: self) { owner, valid in
                owner.mainView.signUpButton.isEnabled = valid
                owner.mainView.signUpButton.backgroundColor = valid ? .blue : .red
            }
            .disposed(by: disposeBag)
        
        output.signUpSuccess
            .drive(with: self) { owner, _ in
                print("회원가입 성공")
            }
            .disposed(by: disposeBag)
    }

}

