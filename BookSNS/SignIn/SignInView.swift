//
//  SignUpView.swift
//  BookSNS
//
//  Created by 민지은 on 2024/04/11.
//

import UIKit
import SnapKit

class SignInView: BaseView {

    let emailTextField = UITextField()
    let passwordTextField = UITextField()
    
    let signInButton = UIButton()
    
    override func configureHierarchy() {
        addSubview(emailTextField)
        addSubview(passwordTextField)
        addSubview(signInButton)
    }
    
    override func configureLayout() {
        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(50)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(20)
            make.height.equalTo(40)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(50)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(20)
            make.height.equalTo(40)
        }

        signInButton.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(50)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(20)
            make.height.equalTo(40)
        }
    }
    
    override func configureView() {
        emailTextField.placeholder = "이메일"
        passwordTextField.placeholder = "비밀번호"
        
        signInButton.setTitle("로그인", for: .normal)
        signInButton.backgroundColor = .black
        signInButton.setTitleColor(.white, for: .normal)
    }
}

