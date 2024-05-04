//
//  SignInViewController.swift
//  BookSNS
//
//  Created by 민지은 on 2024/04/11.
//

import UIKit
import RxSwift
import RxCocoa

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
        
        mainView.passwordTextField.rx.isSecureTextEntry.onNext(true)
        
        mainView.signUpButton.rx.tap
            .subscribe(with: self) { owner, _ in
                let vc = SignUpViewController()
                owner.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)
        
        output.signInValidation
            .drive(with: self) { owner, valid in
                owner.mainView.signInButton.isEnabled = valid
                owner.mainView.signInButton.backgroundColor = valid ? Color.mainColor : Color.lightPoint
            }
            .disposed(by: disposeBag)
        
        output.signInSuccess
            .drive(with: self) { owner, _ in
                print("로그인 성공")
                let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
                
                let sceneDelegate = windowScene?.delegate as? SceneDelegate
                
                let vc = CustomTabBarController()

                sceneDelegate?.window?.rootViewController = vc
                sceneDelegate?.window?.makeKeyAndVisible()
            }
            .disposed(by: disposeBag)
    }
}
