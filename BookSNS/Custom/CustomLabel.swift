//
//  CustomLabel.swift
//  BookSNS
//
//  Created by 민지은 on 2024/05/11.
//

import UIKit

final class CustomLabel: UILabel {
    
    init(size: CGFloat, weight: UIFont.Weight, color: UIColor, text: String) {
        super.init(frame: .zero)
        
        font = .systemFont(ofSize: size, weight: weight)
        textColor = color
        self.text = text
        numberOfLines = 0
    }

    init(size: CGFloat, weight: UIFont.Weight, color: UIColor, text: String, alignment: NSTextAlignment) {
        super.init(frame: .zero)
        
        font = .systemFont(ofSize: size, weight: weight)
        textColor = color
        self.text = text
        numberOfLines = 0
        textAlignment = alignment
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

