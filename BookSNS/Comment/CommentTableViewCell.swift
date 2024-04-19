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
            make.size.equalTo(40)
        }
        
        nickName.snp.makeConstraints { make in
            make.leading.equalTo(profileButton.snp.trailing).offset(8)
            make.top.equalTo(profileButton.snp.top).offset(4)
            make.trailing.equalTo(contentView).inset(12)
            make.height.equalTo(20)
        }
        
        comment.snp.makeConstraints { make in
            make.top.equalTo(profileButton.snp.bottom).offset(8)
            make.horizontalEdges.equalTo(contentView).inset(12)
            make.height.greaterThanOrEqualTo(10)
            make.bottom.equalTo(contentView).inset(12)
        }
        
    }

    override func configureView() {
        profileButton.backgroundColor = .yellow
        nickName.backgroundColor = .orange
        comment.backgroundColor = .blue
        comment.numberOfLines = 0
    }
}
