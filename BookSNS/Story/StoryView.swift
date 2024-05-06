//
//  StoryView.swift
//  BookSNS
//
//  Created by 민지은 on 2024/04/28.
//

import UIKit
import SnapKit

class StoryView: BaseView {
    
    let stackView = UIStackView()
    let testImage = UIImageView()
    
    let grayView = {
       let view = UIView()
        view.backgroundColor = Color.mainColor?.withAlphaComponent(0.2)
       return view
    }()
    
    let profileImage = {
        let view = UIImageView()
        view.clipsToBounds = true
        view.layer.borderColor = Color.lightPoint?.cgColor
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 25
        return view
    }()
    
    let bookLabel = {
       let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 15, weight: .semibold)
        return label
    }()
    
    let rankLabel = {
       let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 12, weight: .semibold)
        return label
    }()
    
    let dismissButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = .white
        return button
    }()
    
    let linkButton = {
       let button = UIButton()
        button.backgroundColor = Color.mainColor
        button.setTitle("구매하러가기", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        button.clipsToBounds = true
        button.layer.cornerRadius = 25
        return button
    }()
    
    let leftView = UIView()
    let rightView = UIView()

    let prevTapGesture = UITapGestureRecognizer()
    let nextTapGesture = UITapGestureRecognizer()
    
    override func configureHierarchy() {
        addSubview(testImage)
        addSubview(grayView)
        addSubview(stackView)
        addSubview(profileImage)
        addSubview(bookLabel)
        addSubview(rankLabel)
        addSubview(leftView)
        addSubview(rightView)
        addSubview(linkButton)
        addSubview(dismissButton)
        leftView.addGestureRecognizer(prevTapGesture)
        rightView.addGestureRecognizer(nextTapGesture)
    }
    
    override func configureLayout() {
        stackView.snp.makeConstraints { make in
            make.top.equalTo(testImage.snp.top)
                .offset(12)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(4)
            make.height.equalTo(2)
        }
        
        testImage.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide)
        }
        
        grayView.snp.makeConstraints { make in
            make.edges.equalTo(testImage)
        }
        
        profileImage.snp.makeConstraints { make in
            make.top.equalTo(stackView.snp.bottom).offset(12)
            make.leading.equalTo(self).inset(12)
            make.size.equalTo(50)
        }
        
        bookLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImage.snp.top).offset(4)
            make.leading.equalTo(profileImage.snp.trailing).offset(8)
            make.trailing.equalTo(dismissButton.snp.leading).offset(-12)
            make.height.equalTo(16)
        }
        
        rankLabel.snp.makeConstraints { make in
            make.height.equalTo(13)
            make.top.equalTo(bookLabel.snp.bottom).offset(4)
            make.leading.equalTo(profileImage.snp.trailing).offset(8)
            make.trailing.equalTo(self).inset(12)
        }
        
        dismissButton.snp.makeConstraints { make in
            make.top.equalTo(profileImage.snp.top)
            make.leading.equalTo(profileImage.snp.trailing).offset(8)
            make.trailing.equalTo(self).inset(12)
            make.size.equalTo(30)
        }
        
        leftView.snp.makeConstraints { make in
            make.leading.top.bottom.equalTo(self)
            make.trailing.equalTo(self.snp.centerX)
        }
        
        rightView.snp.makeConstraints { make in
            make.trailing.top.bottom.equalTo(self)
            make.leading.equalTo(self.snp.centerX)
        }
        
        linkButton.snp.makeConstraints { make in
            make.centerX.equalTo(safeAreaLayoutGuide)
            make.height.equalTo(50)
            make.width.equalTo(150)
            make.bottom.equalTo(safeAreaLayoutGuide).inset(40)
        }
    }
    
    override func configureView() {
        
        profileImage.backgroundColor = .white
        profileImage.image = UIImage(named: "Books")
        
        stackView.axis = .horizontal
        stackView.spacing = 4
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false

        leftView.backgroundColor = .clear
        rightView.backgroundColor = .clear
        
        testImage.contentMode = .scaleAspectFill
    }
}
