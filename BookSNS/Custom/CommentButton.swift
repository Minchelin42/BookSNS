//
//  CommentButton.swift
//  BookSNS
//
//  Created by 민지은 on 2024/04/23.
//

import UIKit

class CommentButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        clipsToBounds = true
        layer.cornerRadius = 14
        backgroundColor = Color.mainColor
        setImage(UIImage(systemName: "chevron.up"), for: .normal)
        tintColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
