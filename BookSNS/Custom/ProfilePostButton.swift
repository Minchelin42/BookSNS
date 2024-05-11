//
//  ProfilePostButton.swift
//  BookSNS
//
//  Created by 민지은 on 2024/04/23.
//

import UIKit

final class ProfilePostButton: UIButton {
    
    init(image: String, background: UIColor) {
        super.init(frame: .zero)

        clipsToBounds = true
        layer.cornerRadius = 21
        layer.borderWidth = 1
        layer.borderColor = Color.pointColor?.cgColor
        
        setImage(UIImage(named: image), for: .normal)
        backgroundColor = background
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

