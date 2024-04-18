//
//  HomeTableViewCell.swift
//  BookSNS
//
//  Created by 민지은 on 2024/04/16.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class HomeTableViewCell: BaseTableViewCell {
    
    static let identifier = "HomeTableViewCell"
    
    var disposeBag = DisposeBag()
    
    let profileButton = UIButton()
    let nickName = UILabel()
    
    let postImage = UIImageView()
    let comment = UIButton()
    let save = UIButton()
    let textView = UILabel()
    
    //책 정보는 일단 나중에 생각
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        disposeBag = DisposeBag()
        postImage.image = nil
        save.setImage(nil, for: .normal)
    }

    override func configureHierarchy() {
        contentView.addSubview(profileButton)
        contentView.addSubview(nickName)
        contentView.addSubview(postImage)
        contentView.addSubview(comment)
        contentView.addSubview(save)
        contentView.addSubview(textView)
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
        
        postImage.snp.makeConstraints { make in
            make.top.equalTo(profileButton.snp.bottom).offset(12)
            make.horizontalEdges.equalTo(contentView)
            make.height.equalTo(UIScreen.main.bounds.width * 0.9)
        }
        
        comment.snp.makeConstraints { make in
            make.leading.equalTo(contentView).inset(12)
            make.top.equalTo(postImage.snp.bottom).offset(8)
            make.size.equalTo(30)
        }
        
        save.snp.makeConstraints { make in
            make.trailing.equalTo(contentView).inset(12)
            make.top.equalTo(comment.snp.top)
            make.size.equalTo(30)
        }
        
        textView.snp.makeConstraints { make in
            make.top.equalTo(comment.snp.bottom).offset(8)
            make.horizontalEdges.equalTo(contentView).inset(12)
            make.height.lessThanOrEqualTo(100)
            make.bottom.equalTo(contentView).inset(12)
        }
        
    }
    
    override func configureView() {
        profileButton.backgroundColor = .yellow
        nickName.backgroundColor = .orange
        postImage.backgroundColor = .green
        comment.setImage(UIImage(systemName: "message"), for: .normal)
        comment.tintColor = .black
        save.setImage(UIImage(named: "Bookmark"), for: .normal)
        save.tintColor = .black
        textView.backgroundColor = .cyan
        textView.numberOfLines = 0
    }
    
}
