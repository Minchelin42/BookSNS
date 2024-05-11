//
//  ProfileOptionButton.swift
//  BookSNS
//
//  Created by 민지은 on 2024/05/11.
//

import UIKit

final class ProfileOptionButton: UIButton {
    
    init(title: String) {
        super.init(frame: .zero)
        
        clipsToBounds = true
        layer.cornerRadius = 10
        layer.borderWidth = 1
        layer.borderColor = Color.lightPoint?.cgColor
        setTitle(title, for: .normal)
        titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
        setTitleColor(Color.mainColor, for: .normal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
