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
    
    let profileButton = UIButton(type: .custom)
    let nickName = UILabel()
    
    let optionButton = UIButton(type: .system)
    let followButton = {
       let button = UIButton()
        button.backgroundColor = Color.mainColor
        button.setTitle("테스트", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 11, weight: .medium)
        button.setTitleColor(.white, for: .normal)
        button.clipsToBounds = true
        button.layer.cornerRadius = 7
        button.layer.borderWidth = 1
        button.layer.borderColor = Color.mainColor?.cgColor
        return button
    }()
    let postImage = UIScrollView()
    let pageControl = UIPageControl()
    
    let comment = UIButton()
    let save = UIButton()
    let textView = UILabel()
    
    let cardView = BookCardView()
    let tapGesture = UITapGestureRecognizer()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        disposeBag = DisposeBag()
        profileButton.setImage(nil, for: .normal)
        save.setImage(nil, for: .normal)
        cardView.unknownView.isHidden = false
    }

    override func configureHierarchy() {
        contentView.addSubview(profileButton)
        contentView.addSubview(nickName)
        contentView.addSubview(followButton)
        contentView.addSubview(optionButton)
        contentView.addSubview(postImage)
        contentView.addSubview(pageControl)
        contentView.addSubview(comment)
        contentView.addSubview(save)
        contentView.addSubview(textView)
        contentView.addSubview(cardView)

        cardView.addGestureRecognizer(tapGesture)
    }
    
    override func configureLayout() {
        profileButton.snp.makeConstraints { make in
            make.top.leading.equalTo(contentView).inset(8)
            make.size.equalTo(34)
        }
        
        nickName.snp.makeConstraints { make in
            make.leading.equalTo(profileButton.snp.trailing).offset(8)
            make.centerY.equalTo(profileButton)
            make.trailing.equalTo(optionButton.snp.leading).offset(-12)
            make.height.equalTo(20)
        }

        optionButton.snp.makeConstraints { make in
            make.centerY.equalTo(profileButton)
            make.size.equalTo(30)
            make.trailing.equalTo(contentView).inset(12)
        }
        
        followButton.snp.makeConstraints { make in
            make.centerY.equalTo(profileButton)
            make.width.equalTo(60)
            make.height.equalTo(30)
            make.trailing.equalTo(contentView).inset(12)
        }
        
        postImage.snp.makeConstraints { make in
            make.top.equalTo(profileButton.snp.bottom).offset(8)
            make.horizontalEdges.equalTo(contentView)
            make.width.equalTo(UIScreen.main.bounds.width)
            make.height.equalTo(UIScreen.main.bounds.width * 0.9)
        }
        
        pageControl.snp.makeConstraints { make in
            make.centerX.equalTo(contentView)
            make.top.equalTo(postImage.snp.bottom).offset(8)
            make.height.equalTo(10)
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
            make.horizontalEdges.equalTo(contentView).inset(16)
            make.height.greaterThanOrEqualTo(10)
        }
        
        cardView.snp.makeConstraints { make in
            make.top.equalTo(textView.snp.bottom).offset(12)
            make.horizontalEdges.equalTo(contentView).inset(12)
            make.height.equalTo(100)
            make.bottom.equalTo(contentView).inset(8)
        }

    }
    
    override func configureView() {
        super.configureView()
    
        profileButton.clipsToBounds = true
        profileButton.layer.cornerRadius = 17
        profileButton.layer.borderWidth = 1
        profileButton.layer.borderColor = Color.lightPoint?.cgColor

        nickName.font = .systemFont(ofSize: 14, weight: .medium)
        
        optionButton.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        optionButton.tintColor = Color.mainColor
        optionButton.showsMenuAsPrimaryAction = true

        postImage.isPagingEnabled = true
        postImage.showsHorizontalScrollIndicator = false
        
        pageControl.hidesForSinglePage = true
        pageControl.pageIndicatorTintColor = Color.lightPoint
        pageControl.currentPageIndicatorTintColor = Color.mainColor
        
        comment.setImage(UIImage(named: "Comment"), for: .normal)
        
        save.setImage(UIImage(named: "Bookmark"), for: .normal)

        textView.numberOfLines = 0
        textView.font = .systemFont(ofSize: 13, weight: .medium)
        
        cardView.clipsToBounds = true
        cardView.layer.cornerRadius = 16
        cardView.layer.borderWidth = 1
        cardView.layer.borderColor = Color.lightPoint?.cgColor
    }

}
