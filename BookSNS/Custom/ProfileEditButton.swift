//
//  ProfileEditButton.swift
//  BookSNS
//
//  Created by 민지은 on 2024/04/23.
//

import UIKit

final class ProfileEditButton: UIButton {
    
    init(title: String) {
        super.init(frame: .zero)
        
        backgroundColor = Color.mainColor
        clipsToBounds = true
        layer.cornerRadius = 10
        setTitle(title, for: .normal)
        titleLabel?.textColor = .white
        titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
