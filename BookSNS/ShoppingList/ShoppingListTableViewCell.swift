//
//  ShoppingListTableViewCell.swift
//  BookSNS
//
//  Created by 민지은 on 2024/05/03.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class ShoppingListTableViewCell: BaseTableViewCell {
    
    static let identifier = "ShoppingListTableViewCell"
    
    var disposeBag = DisposeBag()
    
    let bookImage = {
        let view = UIImageView()
        view.image = UIImage(named: "Books")
        view.clipsToBounds = true
        view.layer.cornerRadius = 25
        view.layer.borderWidth = 1
        view.layer.borderColor = Color.lightPoint?.cgColor
        return view
    }()
    
    let titleLabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .medium)
        label.textColor = Color.mainColor
        return label
    }()
    
    let priceLabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .medium)
        label.textColor = .black
        return label
    }()
    
    let dateLabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .medium)
        label.textColor = Color.pointColor
        return label
    }()
    
    let completeLabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .semibold)
        label.textColor = Color.bluePoint
        label.text = "결제완료"
        return label
    }()
    

    override func prepareForReuse() {
        super.prepareForReuse()
        
        disposeBag = DisposeBag()
    }

    override func configureHierarchy() {
        contentView.addSubview(bookImage)
        contentView.addSubview(titleLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(completeLabel)
    }
    
    override func configureLayout() {
        bookImage.snp.makeConstraints { make in
            make.centerY.equalTo(contentView)
            make.leading.equalTo(contentView).inset(20)
            make.size.equalTo(50)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.bottom.equalTo(bookImage.snp.centerY)
            make.leading.equalTo(bookImage.snp.trailing).offset(12)
            make.trailing.equalTo(dateLabel.snp.leading).offset(-12)
            make.height.equalTo(22)
        }
        
        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom)
            make.leading.equalTo(titleLabel.snp.leading)
            make.trailing.equalTo(titleLabel.snp.trailing)
            make.height.equalTo(22)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.top)
            make.trailing.equalTo(contentView).inset(20)
            make.height.equalTo(22)
            make.width.equalTo(66)
        }
        
        completeLabel.snp.makeConstraints { make in
            make.top.equalTo(priceLabel.snp.top)
            make.trailing.equalTo(contentView).inset(20)
            make.height.equalTo(22)
            make.width.equalTo(66)
        }
    }

}
