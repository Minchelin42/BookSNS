//
//  InputImageButton.swift
//  BookSNS
//
//  Created by 민지은 on 2024/04/23.
//

import UIKit

final class InputImageButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        clipsToBounds = true
        layer.cornerRadius = 4
        backgroundColor = Color.lightPoint
        setImage(UIImage(systemName: "plus"), for: .normal)
        tintColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
