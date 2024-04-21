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
    
    let optionButton = UIButton(type: .system)

    
    let postImage = UIImageView()
    let comment = UIButton()
    let save = UIButton()
    let textView = UILabel()
    
    let cardView = BookCardView()
    let tapGesture = UITapGestureRecognizer()

    override func prepareForReuse() {
        super.prepareForReuse()
        
        disposeBag = DisposeBag()
        postImage.image = nil
        save.setImage(nil, for: .normal)
        cardView.unknownView.isHidden = false
    }

    override func configureHierarchy() {
        contentView.addSubview(profileButton)
        contentView.addSubview(nickName)
        contentView.addSubview(optionButton)
        contentView.addSubview(postImage)
        contentView.addSubview(comment)
        contentView.addSubview(save)
        contentView.addSubview(textView)
        contentView.addSubview(cardView)

        cardView.addGestureRecognizer(tapGesture)
    }
    
    override func configureLayout() {
        profileButton.snp.makeConstraints { make in
            make.top.leading.equalTo(contentView).inset(12)
            make.size.equalTo(40)
        }
        
        nickName.snp.makeConstraints { make in
            make.leading.equalTo(profileButton.snp.trailing).offset(8)
            make.top.equalTo(profileButton.snp.top).offset(4)
            make.trailing.equalTo(optionButton.snp.leading).offset(-12)
            make.height.equalTo(20)
        }
        
        optionButton.snp.makeConstraints { make in
            make.centerY.equalTo(profileButton)
            make.size.equalTo(30)
            make.trailing.equalTo(contentView).inset(12)
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
            make.height.greaterThanOrEqualTo(10)
        }
        
        cardView.snp.makeConstraints { make in
            make.top.equalTo(textView.snp.bottom).offset(12)
            make.horizontalEdges.equalTo(contentView).inset(12)
            make.height.equalTo(100)
            make.bottom.equalTo(contentView).inset(12)
        }

    }
    
    override func configureView() {
        super.configureView()
        profileButton.backgroundColor = .yellow
        nickName.backgroundColor = .orange
        
        optionButton.backgroundColor = .purple
        optionButton.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        optionButton.showsMenuAsPrimaryAction = true

        
        postImage.backgroundColor = .green
        comment.setImage(UIImage(systemName: "message"), for: .normal)
        comment.tintColor = .black
        save.setImage(UIImage(named: "Bookmark"), for: .normal)
        save.tintColor = .black
        textView.backgroundColor = .cyan
        textView.numberOfLines = 0
        cardView.backgroundColor = .systemPink
        cardView.clipsToBounds = true
        cardView.layer.cornerRadius = 16
    }

}
