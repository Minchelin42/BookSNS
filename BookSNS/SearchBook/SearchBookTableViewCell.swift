//
//  SearchBookTableViewCell.swift
//  BookSNS
//
//  Created by 민지은 on 2024/04/14.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class SearchBookTableViewCell: BaseTableViewCell {

    static let identifier = "ITunesTableViewCell"
    
    var disposeBag = DisposeBag()
    
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        disposeBag = DisposeBag()
    }
    
    override func configureHierarchy() {
        contentView.addSubview(bookImage)
        contentView.addSubview(title)
        contentView.addSubview(price)
    }
    
    override func configureLayout() {
        bookImage.snp.makeConstraints { make in
            make.top.leading.bottom.equalTo(contentView).inset(12)
            make.width.equalTo(70)
        }
        
        title.snp.makeConstraints { make in
            make.top.equalTo(bookImage.snp.top).offset(4)
            make.leading.equalTo(bookImage.snp.trailing).offset(8)
            make.trailing.equalTo(contentView).offset(-10)
            make.bottom.lessThanOrEqualTo(price.snp.top).offset(-8)
        }
        
        price.snp.makeConstraints { make in
            make.bottom.equalTo(bookImage.snp.bottom).inset(4)
            make.leading.equalTo(bookImage.snp.trailing).offset(8)
            make.trailing.equalTo(contentView).offset(-10)
            make.height.equalTo(16)
        }
    }
    
    override func configureView() {
        title.backgroundColor = .orange
        price.backgroundColor = .brown
    }

}
