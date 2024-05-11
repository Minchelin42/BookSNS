//
//  CommentTextField.swift
//  BookSNS
//
//  Created by 민지은 on 2024/04/23.
//

import UIKit

final class CommentTextField: UITextField {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        clipsToBounds = true
        layer.cornerRadius = 20
        layer.borderColor = Color.mainColor?.cgColor
        layer.borderWidth = 1
        placeholder = "    댓글 입력"
        font = .systemFont(ofSize: 13, weight: .medium)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

