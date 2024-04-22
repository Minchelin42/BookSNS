//
//  EditProfileView.swift
//  BookSNS
//
//  Created by 민지은 on 2024/04/22.
//

import UIKit
import SnapKit

class EditProfileView: BaseView {
    
    let profileImageView = UIImageView()
    let imageEditButton = UIButton()
    let nickNameLabel = {
        let label = UILabel()
        label.text = "닉네임"
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        return label
    }()
    let nickNameTextField = UITextField()
    let editButton = {
       let button = UIButton()
        button.backgroundColor = .lightGray
        button.setTitle("수정하기", for: .normal)
        button.setTitleColor(.white, for: .normal)
        return button
    }()

    override func configureHierarchy() {
        addSubview(profileImageView)
        addSubview(imageEditButton)
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
            make.size.equalTo(45)
            make.leading.equalTo(profileImageView.snp.trailing).inset(30)
            make.bottom.equalTo(profileImageView.snp.bottom).offset(8)
        }
        
        nickNameLabel.snp.makeConstraints { make in
            make.leading.equalTo(safeAreaLayoutGuide).inset(30)
            make.top.equalTo(profileImageView.snp.bottom).offset(60)
            make.height.equalTo(20)
            make.width.equalTo(50)
        }
        
        nickNameTextField.snp.makeConstraints { make in
            make.centerY.equalTo(nickNameLabel)
            make.leading.equalTo(nickNameLabel.snp.trailing).offset(8)
            make.trailing.equalTo(safeAreaLayoutGuide).inset(30)
            make.height.equalTo(50)
        }
        
        editButton.snp.makeConstraints { make in
            make.bottom.equalTo(safeAreaLayoutGuide).inset(30)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(30)
            make.height.equalTo(70)
        }
    }
    
    override func configureView() {
        profileImageView.backgroundColor = .orange
        imageEditButton.backgroundColor = .blue
        nickNameTextField.backgroundColor = .systemPink
    }

}
