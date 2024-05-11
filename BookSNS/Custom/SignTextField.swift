//
//  SignTextField.swift
//  BookSNS
//
//  Created by 민지은 on 2024/04/23.
//

import UIKit

final class SignTextField: UITextField {

    init(placeholderText: String) {
        super.init(frame: .zero)
        
        placeholder = placeholderText
        backgroundColor = .white
        clipsToBounds = true
        layer.cornerRadius = 8
        layer.borderColor = Color.lightPoint?.cgColor
        layer.borderWidth = 1
        font = .systemFont(ofSize: 15, weight: .medium)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
