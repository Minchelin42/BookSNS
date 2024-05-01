//
//  ProfilePostButton.swift
//  BookSNS
//
//  Created by 민지은 on 2024/04/23.
//

import UIKit

class ProfilePostButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        clipsToBounds = true
        layer.cornerRadius = 21
        layer.borderWidth = 1
        layer.borderColor = Color.pointColor?.cgColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
