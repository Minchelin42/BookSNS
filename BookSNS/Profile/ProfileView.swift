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
    let profileName = CustomLabel(size: 24, weight: .semibold, color: .black, text: "", alignment: .center)

    let postLabel = CustomLabel(size: 13, weight: .semibold, color: .black, text: "게시글")
    let postNumLabel = CustomLabel(size: 13, weight: .semibold, color: .black, text: "", alignment: .center)
    
    let followingLabel = CustomLabel(size: 13, weight: .semibold, color: .black, text: "팔로잉")
    let followingButton = NumberButton()
    
    let followerLabel = CustomLabel(size: 13, weight: .semibold, color: .black, text: "팔로워")
    let followerButton = NumberButton()
    
    let profileEditButton = ProfileOptionButton(title: "프로필 수정")
    
    //지은
    let shoppingListButton = ProfileOptionButton(title: "구매 내역")
    
    let postButton = ProfilePostButton(image: "Grid.fill", background: Color.mainColor!)
    let scrapButton = ProfilePostButton(image: "Bookmark", background: .white)
    
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
        addSubview(shoppingListButton)
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
            make.width.equalTo((UIScreen.main.bounds.width - 48) / 2)
            make.leading.equalTo(safeAreaLayoutGuide).inset(16)
        }
        
        shoppingListButton.snp.makeConstraints { make in
            make.top.equalTo(postNumLabel.snp.bottom).offset(24)
            make.height.equalTo(40)
            make.width.equalTo((UIScreen.main.bounds.width - 48) / 2)
            make.trailing.equalTo(safeAreaLayoutGuide).inset(16)
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
