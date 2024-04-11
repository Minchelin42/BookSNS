//
//  SignInViewController.swift
//  BookSNS
//
//  Created by 민지은 on 2024/04/11.
//

import UIKit

class SignInViewController: RxBaseViewController {
    
    let mainView = SignInView()
    let viewModel = SignInViewModel()
    
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let input = SignInViewModel.Input(emailText: mainView.emailTextField.rx.text.orEmpty.asObservable(), passwordText: mainView.passwordTextField.rx.text.orEmpty.asObservable(), signInButtonTapped: mainView.signInButton.rx.tap.asObservable())
        
        let output = viewModel.transform(input: input)
        
        output.signInValidation
            .drive(with: self) { owner, valid in
                owner.mainView.signInButton.isEnabled = valid
                owner.mainView.signInButton.backgroundColor = valid ? .blue : .red
            }
            .disposed(by: disposeBag)
        
        output.signInSuccess
            .drive(with: self) { owner, _ in
                print("로그인 성공")
                owner.navigationController?.pushViewController(SignUpViewController(), animated: true)
            }
            .disposed(by: disposeBag)
    }
}
