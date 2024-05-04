//
//  BookCardView.swift
//  BookSNS
//
//  Created by 민지은 on 2024/04/21.
//

import UIKit
import SnapKit

class UnknownView: BaseView {
    
    let bookImage = {
       let view = UIImageView()
        view.image = UIImage(named: "Book")
        return view
    }()
    
    let questionImage = {
       let view = UIImageView()
        view.image = UIImage(named: "QuestionMark")
        return view
    }()
    
    override func configureHierarchy() {
        addSubview(bookImage)
        addSubview(questionImage)
    }
    
    override func configureLayout() {
        bookImage.snp.makeConstraints { make in
            make.center.equalTo(safeAreaLayoutGuide)
            make.size.equalTo(60)
        }
        
        questionImage.snp.makeConstraints { make in
            make.centerX.equalTo(safeAreaLayoutGuide)
            make.top.equalTo(bookImage.snp.top)
            make.size.equalTo(40)
        }
    }
    
    override func configureView() {
        backgroundColor = Color.lightPoint
    }
}

class BookCardView: BaseView {
    
    let bookImage = {
        let image = UIImageView()
        image.clipsToBounds = true
        image.layer.cornerRadius = 10
        image.backgroundColor = .blue
        return image
    }()
    
    let title = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .semibold)
        label.textColor = .black
        label.numberOfLines = 0
        return label
    }()
    
    let price = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = Color.pointColor
        return label
    }()
    
    let linkButton = {
        let button = UIButton()
        button.clipsToBounds = true
        button.layer.cornerRadius = 10
        button.backgroundColor = Color.mainColor
        button.setTitle("상세페이지", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 13, weight: .medium)
        return button
    }()
    
    let unknownView = UnknownView()

    override func configureHierarchy() {
        addSubview(bookImage)
        addSubview(title)
        addSubview(price)
        addSubview(linkButton)
        addSubview(unknownView)
    }
    
    override func configureLayout() {
        bookImage.snp.makeConstraints { make in
            make.top.leading.bottom.equalTo(safeAreaLayoutGuide).inset(15)
            make.width.equalTo(70)
        }
        
        title.snp.makeConstraints { make in
            make.leading.equalTo(bookImage.snp.trailing).offset(8)
            make.trailing.equalTo(safeAreaLayoutGuide).offset(-10)
            make.top.equalTo(bookImage.snp.top).offset(4)
            make.bottom.lessThanOrEqualTo(linkButton.snp.top).offset(-4)
        }
        
        price.snp.makeConstraints { make in
            make.leading.equalTo(bookImage.snp.trailing).offset(8)
            make.trailing.equalTo(linkButton).offset(-10)
            make.height.equalTo(16)
            make.bottom.equalTo(bookImage.snp.bottom)
        }
        
        linkButton.snp.makeConstraints { make in
            make.bottom.equalTo(safeAreaLayoutGuide).offset(-12)
            make.trailing.equalTo(safeAreaLayoutGuide).offset(-12)
            make.height.equalTo(32)
            make.width.equalTo(80)
        }
        
        unknownView.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide)
        }
    }
    
    override func configureView() {
        unknownView.clipsToBounds = true
        unknownView.layer.cornerRadius = 16
        backgroundColor = .white
    }
    
}
