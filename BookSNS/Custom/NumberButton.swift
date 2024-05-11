//
//  NumberButton.swift
//  BookSNS
//
//  Created by 민지은 on 2024/05/11.
//

import UIKit

final class NumberButton: UIButton {
    
    init() {
        super.init(frame: .zero)
        
        titleLabel?.font = .systemFont(ofSize: 13, weight: .semibold)
        setTitleColor(Color.mainColor, for: .normal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

