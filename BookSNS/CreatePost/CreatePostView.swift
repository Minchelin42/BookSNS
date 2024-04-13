//
//  CreatePostView.swift
//  BookSNS
//
//  Created by 민지은 on 2024/04/13.
//

import UIKit
import SnapKit

class CreatePostView: BaseView {
 
    lazy var textView = {
        let textView = UITextView()
        textView.text = placeholderText
        textView.textColor = .lightGray
        return textView
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
        addSubview(textView)
        addSubview(createButton)
    }
    
    override func configureLayout() {
        textView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(50)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(50)
            make.height.equalTo(200)
        }
        
        createButton.snp.makeConstraints { make in
            make.top.equalTo(textView.snp.bottom).offset(50)
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
