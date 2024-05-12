//
//  FollowListTableViewCell.swift
//  BookSNS
//
//  Created by 민지은 on 2024/04/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class FollowListTableViewCell: BaseTableViewCell, CellType {

    var disposeBag = DisposeBag()
    
    let profileButton = UIButton()
    let nameLabel = UILabel()
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        disposeBag = DisposeBag()
        profileButton.setImage(nil, for: .normal)
    }

    override func configureHierarchy() {
        contentView.addSubview(profileButton)
        contentView.addSubview(nameLabel)
        contentView.addSubview(followButton)
    }
    
    override func configureLayout() {
        profileButton.snp.makeConstraints { make in
            make.centerY.equalTo(contentView)
            make.size.equalTo(40)
            make.leading.equalTo(contentView).inset(12)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.centerY.equalTo(profileButton)
            make.leading.equalTo(profileButton.snp.trailing).offset(8)
            make.width.equalTo(100)
            make.height.equalTo(20)
        }
        
        followButton.snp.makeConstraints { make in
            make.centerY.equalTo(profileButton)
            make.width.equalTo(60)
            make.height.equalTo(30)
            make.trailing.equalTo(contentView).inset(12)
        }
    }
    
    override func configureView() {
        super.configureView()

        profileButton.clipsToBounds = true
        profileButton.layer.cornerRadius = 20
        profileButton.layer.borderWidth = 1
        profileButton.layer.borderColor = Color.lightPoint?.cgColor
        
    }

}
