//
//  CreatePostView.swift
//  BookSNS
//
//  Created by 민지은 on 2024/04/13.
//

import UIKit
import SnapKit

class CreatePostView: BaseView {
    
    let imageRegisterButton = {
        let button = UIButton()
        button.setTitle("이미지 등록하기", for: .normal)
        button.clipsToBounds = true
        button.layer.cornerRadius = 10
        button.backgroundColor = .black
        button.setTitleColor(.white, for: .normal)
        return button
    }()
 
    lazy var textView = {
        let textView = UITextView()
        textView.text = placeholderText
        textView.textColor = .lightGray
        return textView
    }()
    
    let searchBookButton = {
        let button = UIButton()
        button.setTitle("책 검색하기", for: .normal)
        button.clipsToBounds = true
        button.layer.cornerRadius = 10
        button.backgroundColor = .black
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    let createButton = {
        let button = UIButton()
        button.setTitle("등록하기", for: .normal)
        button.clipsToBounds = true
        button.layer.cornerRadius = 10
        button.backgroundColor = .black
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    let placeholderText = "placeHolder"
    
    override func configureHierarchy() {
        addSubview(imageRegisterButton)
        addSubview(textView)
        addSubview(searchBookButton)
        addSubview(createButton)
    }
    
    override func configureLayout() {
        
        imageRegisterButton.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(50)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(50)
            make.height.equalTo(50)
        }
        
        textView.snp.makeConstraints { make in
            make.top.equalTo(imageRegisterButton.snp.bottom).offset(50)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(50)
            make.height.equalTo(200)
        }
        
        searchBookButton.snp.makeConstraints { make in
            make.top.equalTo(textView.snp.bottom).offset(50)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(50)
            make.height.equalTo(50)
        }
        
        createButton.snp.makeConstraints { make in
            make.top.equalTo(searchBookButton.snp.bottom).offset(50)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(50)
            make.height.equalTo(50)
        }
    }
    
    override func configureView() {
        textView.backgroundColor = .yellow
        textView.delegate = self
    }
  
}

extension CreatePostView: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == placeholderText {
            textView.text = nil
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = placeholderText
            textView.textColor = .lightGray
        }
    }
    
    
}
