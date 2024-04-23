//
//  ProfileEditButton.swift
//  BookSNS
//
//  Created by 민지은 on 2024/04/23.
//

import UIKit

class ProfileEditButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = Color.mainColor
        clipsToBounds = true
        layer.cornerRadius = 10
        setTitle("프로필 수정", for: .normal)
        titleLabel?.textColor = .white
        titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
