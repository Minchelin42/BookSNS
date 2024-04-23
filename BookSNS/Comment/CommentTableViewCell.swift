//
//  CommentTableViewCell.swift
//  BookSNS
//
//  Created by 민지은 on 2024/04/18.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class CommentTableViewCell: BaseTableViewCell {

    static let identifier = "CommentTableViewCell"
    
    var disposeBag = DisposeBag()
    
    let profileButton = UIButton()
    let nickName = UILabel()

    let comment = UILabel()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        disposeBag = DisposeBag()
    }
    
    override func configureHierarchy() {
        contentView.addSubview(profileButton)
        contentView.addSubview(nickName)
        contentView.addSubview(comment)
    }
    
    override func configureLayout() {
        profileButton.snp.makeConstraints { make in
            make.top.leading.equalTo(contentView).inset(12)
            make.size.equalTo(34)
        }
        
        nickName.snp.makeConstraints { make in
            make.leading.equalTo(profileButton.snp.trailing).offset(8)
            make.top.equalTo(profileButton.snp.top)
            make.trailing.equalTo(contentView).inset(12)
            make.height.equalTo(20)
        }
        
        comment.snp.makeConstraints { make in
            make.top.equalTo(nickName.snp.bottom)
            make.leading.equalTo(profileButton.snp.trailing).offset(8)
            make.trailing.equalTo(contentView).inset(12)
            make.height.greaterThanOrEqualTo(10)
            make.bottom.equalTo(contentView).inset(12)
        }
        
    }

    override func configureView() {
        super.configureView()
        profileButton.clipsToBounds = true
        profileButton.layer.cornerRadius = 17
        profileButton.layer.borderWidth = 1
        profileButton.layer.borderColor = Color.lightPoint?.cgColor
        
        nickName.font = .systemFont(ofSize: 12, weight: .medium)

        comment.font = .systemFont(ofSize: 11, weight: .regular)
        comment.numberOfLines = 0
    }
}
