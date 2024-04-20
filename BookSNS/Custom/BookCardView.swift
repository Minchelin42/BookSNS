//
//  BookCardView.swift
//  BookSNS
//
//  Created by 민지은 on 2024/04/21.
//

import UIKit
import SnapKit

class UnknownView: BaseView {
    override func configureView() {
        backgroundColor = .black
    }
}

class BookCardView: BaseView {
    
    let bookImage = {
        let image = UIImageView()
        image.clipsToBounds = true
        image.layer.cornerRadius = 7
        image.backgroundColor = .blue
        return image
    }()
    
    let title = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.textColor = .black
        return label
    }()
    
    let price = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.textColor = .black
        return label
    }()
    
    let unknownView = UnknownView()

    override func configureHierarchy() {
        addSubview(bookImage)
        addSubview(title)
        addSubview(price)
        addSubview(unknownView)
    }
    
    override func configureLayout() {
        bookImage.snp.makeConstraints { make in
            make.top.leading.bottom.equalTo(safeAreaLayoutGuide).inset(12)
            make.width.equalTo(70)
        }
        
        title.snp.makeConstraints { make in
            make.top.equalTo(bookImage.snp.top).offset(4)
            make.leading.equalTo(bookImage.snp.trailing).offset(8)
            make.trailing.equalTo(safeAreaLayoutGuide).offset(-10)
            make.bottom.lessThanOrEqualTo(price.snp.top).offset(-8)
        }
        
        price.snp.makeConstraints { make in
            make.bottom.equalTo(bookImage.snp.bottom).inset(4)
            make.leading.equalTo(bookImage.snp.trailing).offset(8)
            make.trailing.equalTo(safeAreaLayoutGuide).offset(-10)
            make.height.equalTo(16)
        }
        
        unknownView.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide)
        }
    }
    
    override func configureView() {
        title.backgroundColor = .yellow
        title.numberOfLines = 0
        price.backgroundColor = .brown
    }
    
    
}
