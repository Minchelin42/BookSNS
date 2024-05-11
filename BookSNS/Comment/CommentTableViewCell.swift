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
    
    let profileButton = {
       let button = UIButton()
        button.clipsToBounds = true
        button.layer.cornerRadius = 17
        button.layer.borderWidth = 1
        button.layer.borderColor = Color.lightPoint?.cgColor
        return button
    }()
    let nickName = CustomLabel(size: 12, weight: .medium, color: .black, text: "")
    let comment = CustomLabel(size: 11, weight: .regular, color: .black, text: "")
    
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

}
