//
//  SignUpView.swift
//  BookSNS
//
//  Created by 민지은 on 2024/04/11.
//

import UIKit
import SnapKit

class SignInView: BaseView {

    let emailTextField = SignTextField()
    let passwordTextField = SignTextField()
    
    let signInButton = {
        let button = UIButton()
        button.backgroundColor = Color.mainColor
        button.setTitle("로그인", for: .normal)
        button.clipsToBounds = true
        button.layer.cornerRadius = 25
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 15, weight: .medium)
        return button
    }()
    
    let signUpButton = {
        let button = UIButton()
        button.setTitle("아직 회원이 아니신가요?", for: .normal)
        button.setTitleColor(Color.pointColor, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 15, weight: .medium)
        return button
    }()
    
    override func configureHierarchy() {
        addSubview(emailTextField)
        addSubview(passwordTextField)
        addSubview(signInButton)
        addSubview(signUpButton)
    }
    
    override func configureLayout() {
        emailTextField.snp.makeConstraints { make in
            make.centerY.equalTo(self)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(36)
            make.height.equalTo(50)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(11)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(36)
            make.height.equalTo(50)
        }

        signInButton.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(35)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(36)
            make.height.equalTo(50)
        }
        
        signUpButton.snp.makeConstraints { make in
            make.top.equalTo(signInButton.snp.bottom)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(36)
            make.height.equalTo(50)
        }
    }
    
    override func configureView() {
        emailTextField.placeholder = "    ID"
        passwordTextField.placeholder = "    PW"
    }
}

