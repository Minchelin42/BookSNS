//
//  ProfileView.swift
//  BookSNS
//
//  Created by 민지은 on 2024/04/18.
//

import UIKit
import SnapKit

class ProfileView: BaseView {
    
    let profileImage = UIImageView()
    let profileName = UILabel()
    
    let postLabel = {
        let label = UILabel()
        label.text = "게시글"
        label.font = .systemFont(ofSize: 13, weight: .semibold)
        return label
    }()
    
    let postNumLabel = {
        let label = UILabel()
        label.text = "0"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 13, weight: .semibold)
        return label
    }()
    
    let followingLabel = {
        let label = UILabel()
        label.text = "팔로잉"
        label.font = .systemFont(ofSize: 13, weight: .semibold)
        return label
    }()
    
    let followingButton = {
       let button = UIButton()
        button.setTitle("39", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 13, weight: .semibold)
        button.setTitleColor(Color.mainColor, for: .normal)
        return button
    }()
    
    let followerLabel = {
        let label = UILabel()
        label.text = "팔로워"
        label.font = .systemFont(ofSize: 13, weight: .semibold)
        return label
    }()
    
    let followerButton = {
       let button = UIButton()
        button.setTitle("39", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 13, weight: .semibold)
        button.setTitleColor(Color.mainColor, for: .normal)
        return button
    }()
    
    let profileEditButton = ProfileEditButton()
    
    let postButton = ProfilePostButton()
    let scrapButton = ProfilePostButton()
    
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: configureCollectionViewLayout())
    
    override func configureHierarchy() {
        addSubview(profileImage)
        addSubview(profileName)
        addSubview(postLabel)
        addSubview(postNumLabel)
        addSubview(followingLabel)
        addSubview(followingButton)
        addSubview(followerLabel)
        addSubview(followerButton)
        addSubview(profileEditButton)
        addSubview(postButton)
        addSubview(scrapButton)
        addSubview(collectionView)
    }
    
    override func configureLayout() {
        profileImage.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).inset(16)
            make.centerX.equalTo(self)
            make.size.equalTo(100)
        }
        
        profileName.snp.makeConstraints { make in
            make.top.equalTo(profileImage.snp.bottom).offset(14)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(30)
            make.height.equalTo(22)
            
        }
        
        postLabel.snp.makeConstraints { make in
            make.top.equalTo(profileName.snp.bottom).offset(20)
            make.height.equalTo(22)
            make.width.equalTo(36)
            make.trailing.equalTo(followingLabel.snp.leading).offset(-50)
        }
        
        followingLabel.snp.makeConstraints { make in
            make.top.equalTo(postLabel)
            make.height.equalTo(22)
            make.width.equalTo(36)
            make.centerX.equalTo(self)
        }
        
        followerLabel.snp.makeConstraints { make in
            make.top.equalTo(postLabel)
            make.height.equalTo(22)
            make.width.equalTo(36)
            make.leading.equalTo(followingLabel.snp.trailing).offset(50)
        }
        
        postNumLabel.snp.makeConstraints { make in
            make.top.equalTo(postLabel.snp.bottom)
            make.height.equalTo(22)
            make.width.equalTo(36)
            make.trailing.equalTo(followingButton.snp.leading).offset(-50)
        }
        
        followingButton.snp.makeConstraints { make in
            make.top.equalTo(postNumLabel)
            make.height.equalTo(22)
            make.width.equalTo(36)
            make.centerX.equalTo(self)
        }
        
        followerButton.snp.makeConstraints { make in
            make.top.equalTo(postNumLabel)
            make.height.equalTo(22)
            make.width.equalTo(36)
            make.leading.equalTo(followingButton.snp.trailing).offset(50)
        }
        
        
        profileEditButton.snp.makeConstraints { make in
            make.top.equalTo(postNumLabel.snp.bottom).offset(24)
            make.height.equalTo(40)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(16)
        }
        
        postButton.snp.makeConstraints { make in
            make.top.equalTo(profileEditButton.snp.bottom).offset(8)
            make.height.equalTo(42)
            make.width.equalTo((UIScreen.main.bounds.size.width - 48) / 2)
            make.leading.equalTo(safeAreaLayoutGuide).inset(16)
        }
        
        scrapButton.snp.makeConstraints { make in
            make.top.equalTo(profileEditButton.snp.bottom).offset(8)
            make.height.equalTo(42)
            make.width.equalTo((UIScreen.main.bounds.size.width - 48) / 2)
            make.trailing.equalTo(safeAreaLayoutGuide).inset(16)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(postButton.snp.bottom).offset(8)
            make.horizontalEdges.bottom.equalTo(safeAreaLayoutGuide)
        }
    }
    
    override func configureView() {

        profileImage.clipsToBounds = true
        profileImage.layer.cornerRadius = 50
        profileImage.layer.borderWidth = 1
        profileImage.layer.borderColor = Color.lightPoint?.cgColor
        
        profileName.font = .systemFont(ofSize: 24, weight: .semibold)
        profileName.textAlignment = .center
        
        postButton.setImage(UIImage(named: "Grid.fill"), for: .normal)
        postButton.backgroundColor = Color.mainColor
        scrapButton.setImage(UIImage(named: "Bookmark"), for: .normal)
        
        collectionView.backgroundColor = .white
        
        collectionView.register(PostCollectionViewCell.self, forCellWithReuseIdentifier: PostCollectionViewCell.identifier)
    }
    
    private func configureCollectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: (UIScreen.main.bounds.width - 8) / 3, height: (UIScreen.main.bounds.width - 8) / 3)
        layout.minimumLineSpacing = 2
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 0, left: 2, bottom: 0, right: 2)
        layout.scrollDirection = .vertical

        return layout
        
    }
  
}
