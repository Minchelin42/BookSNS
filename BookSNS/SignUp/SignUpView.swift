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
    let emailLabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize: 11, weight: .medium)
        return label
    }()
    let passwordTextField = SignTextField()
    let passwordLabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize: 11, weight: .medium)
        return label
    }()
    let nickNameTextField = SignTextField()
    
    let emailValidationButton = {
        let button = UIButton()
        button.backgroundColor = Color.pointColor
        button.setTitle("중복 확인", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 13, weight: .semibold)
        button.clipsToBounds = true
        button.layer.cornerRadius = 7
        return button
    }()
    
    let signUpButton = {
        let button = UIButton()
        button.setTitle("가입하기", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 15, weight: .medium)
        button.backgroundColor = Color.mainColor
        button.setTitleColor(.white, for: .normal)
        button.clipsToBounds = true
        button.layer.cornerRadius = 22
        return button
    }()
    
    override func configureHierarchy() {
        addSubview(emailTextField)
        addSubview(emailValidationButton)
        addSubview(emailLabel)
        addSubview(passwordTextField)
        addSubview(passwordLabel)
        addSubview(nickNameTextField)
        addSubview(signUpButton)
    }
    
    override func configureLayout() {
        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(50)
            make.leading.equalTo(safeAreaLayoutGuide).inset(36)
            make.trailing.equalTo(emailValidationButton.snp.leading).offset(-8)
            make.height.equalTo(45)
        }
        
        emailValidationButton.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.top)
            make.trailing.equalTo(safeAreaLayoutGuide).inset(36)
            make.width.equalTo(80)
            make.height.equalTo(45)
        }
        
        emailLabel.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(40)
            make.height.equalTo(22)
        }

        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(emailLabel.snp.bottom).offset(16)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(36)
            make.height.equalTo(45)
        }
        
        passwordLabel.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(40)
            make.height.equalTo(22)
        }

        nickNameTextField.snp.makeConstraints { make in
            make.top.equalTo(passwordLabel.snp.bottom).offset(16)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(36)
            make.height.equalTo(45)
        }

        signUpButton.snp.makeConstraints { make in
            make.top.equalTo(nickNameTextField.snp.bottom).offset(32)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(36)
            make.height.equalTo(45)
        }
    }
    
    override func configureView() {
        emailTextField.placeholder = "  이메일"
        emailLabel.text = "사용가능한 이메일 입니다"
        passwordTextField.placeholder = "  비밀번호"
        passwordLabel.text = "비밀번호는 8자이상으로 입력해주세요"
        nickNameTextField.placeholder = "  닉네임"

    }
}
