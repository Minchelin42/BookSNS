//
//  SignUpView.swift
//  BookSNS
//
//  Created by 민지은 on 2024/04/11.
//

import UIKit
import SnapKit


class SignUpView: BaseView {

    let emailTextField = SignTextField()
    let passwordTextField = SignTextField()
    let nickNameTextField = UITextField()
    
    let emailValidationButton = UIButton()
    let signUpButton = UIButton()
    
    override func configureHierarchy() {
        addSubview(emailTextField)
        addSubview(passwordTextField)
        addSubview(nickNameTextField)
        addSubview(emailValidationButton)
        addSubview(signUpButton)
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
        
        nickNameTextField.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(50)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(20)
            make.height.equalTo(40)
        }
        
        emailValidationButton.snp.makeConstraints { make in
            make.top.equalTo(nickNameTextField.snp.bottom).offset(50)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(20)
            make.height.equalTo(40)
        }
        
        signUpButton.snp.makeConstraints { make in
            make.top.equalTo(emailValidationButton.snp.bottom).offset(50)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(20)
            make.height.equalTo(40)
        }
    }
    
    override func configureView() {
        emailTextField.placeholder = "이메일"
        passwordTextField.placeholder = "비밀번호"
        nickNameTextField.placeholder = "닉네임"
        
        emailValidationButton.setTitle("중복확인", for: .normal)
        emailValidationButton.backgroundColor = .black
        emailValidationButton.setTitleColor(.white, for: .normal)

        signUpButton.setTitle("가입하기", for: .normal)
        signUpButton.backgroundColor = .black
        signUpButton.setTitleColor(.white, for: .normal)
    }
}
