//
//  EditProfileView.swift
//  BookSNS
//
//  Created by 민지은 on 2024/04/22.
//

import UIKit
import SnapKit

class EditProfileView: BaseView {
    
    let profileImageView = {
       let view = UIImageView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 75
        view.layer.borderWidth = 1
        view.layer.borderColor = Color.lightPoint?.cgColor
        return view
    }()
    
    let imageEditButton = {
        let button = UIButton()
        button.backgroundColor = Color.mainColor
        button.clipsToBounds = true
        button.layer.cornerRadius = 25
        button.setImage(UIImage(named: "Picture"), for: .normal)
        return button
    }()
    
    let idLabel = {
        let label = UILabel()
        label.text = "아이디"
        label.font = .systemFont(ofSize: 15, weight: .medium)
        return label
    }()
    
    let userIdLabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .medium)
        return label
    }()
    
    let nickNameLabel = {
        let label = UILabel()
        label.text = "닉네임"
        label.font = .systemFont(ofSize: 15, weight: .medium)
        return label
    }()
    
    let nickNameTextField = SignTextField()
    let editButton = ProfileEditButton()

    override func configureHierarchy() {
        addSubview(profileImageView)
        addSubview(imageEditButton)
        addSubview(idLabel)
        addSubview(userIdLabel)
        addSubview(nickNameLabel)
        addSubview(nickNameTextField)
        addSubview(editButton)
    }
    
    override func configureLayout() {
        profileImageView.snp.makeConstraints { make in
            make.size.equalTo(150)
            make.centerX.equalTo(self)
            make.top.equalTo(safeAreaLayoutGuide).offset(40)
        }
        
        imageEditButton.snp.makeConstraints { make in
            make.size.equalTo(50)
            make.trailing.equalTo(profileImageView.snp.trailing)
            make.bottom.equalTo(profileImageView.snp.bottom)
        }
        
        idLabel.snp.makeConstraints { make in
            make.leading.equalTo(safeAreaLayoutGuide).inset(40)
            make.top.equalTo(profileImageView.snp.bottom).offset(60)
            make.height.equalTo(22)
            make.width.equalTo(50)
        }
        
        userIdLabel.snp.makeConstraints { make in
            make.top.equalTo(idLabel.snp.top)
            make.leading.equalTo(idLabel.snp.trailing).offset(8)
            make.trailing.equalTo(safeAreaLayoutGuide).inset(40)
            make.height.equalTo(22)
        }
        
        nickNameLabel.snp.makeConstraints { make in
            make.leading.equalTo(safeAreaLayoutGuide).inset(40)
            make.top.equalTo(idLabel.snp.bottom).offset(30)
            make.height.equalTo(20)
            make.width.equalTo(50)
        }
        
        nickNameTextField.snp.makeConstraints { make in
            make.centerY.equalTo(nickNameLabel)
            make.leading.equalTo(nickNameLabel.snp.trailing).offset(8)
            make.trailing.equalTo(safeAreaLayoutGuide).inset(40)
            make.height.equalTo(40)
        }
        
        editButton.snp.makeConstraints { make in
            make.bottom.equalTo(safeAreaLayoutGuide).inset(40)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(40)
            make.height.equalTo(50)
        }
    }

}
