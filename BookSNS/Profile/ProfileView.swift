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
    
    let postButton = UIButton()
    let scrapButton = UIButton()
    
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: configureCollectionViewLayout())
    
    override func configureHierarchy() {
        addSubview(profileImage)
        addSubview(profileName)
        addSubview(postButton)
        addSubview(scrapButton)
        addSubview(collectionView)
    }
    
    override func configureLayout() {
        profileImage.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).inset(12)
            make.leading.equalTo(safeAreaLayoutGuide).offset(16)
            make.size.equalTo(70)
        }
        
        profileName.snp.makeConstraints { make in
            make.top.equalTo(profileImage.snp.top).offset(4)
            make.leading.equalTo(profileImage.snp.trailing).offset(12)
            make.trailing.equalTo(safeAreaLayoutGuide).inset(16)
            make.height.equalTo(20)
            
        }
        
        postButton.snp.makeConstraints { make in
            make.top.equalTo(profileImage.snp.bottom).offset(8)
            make.height.equalTo(40)
            make.width.equalTo((UIScreen.main.bounds.size.width - 36) / 2)
            make.leading.equalTo(safeAreaLayoutGuide).inset(12)
        }
        
        scrapButton.snp.makeConstraints { make in
            make.top.equalTo(profileImage.snp.bottom).offset(8)
            make.height.equalTo(40)
            make.width.equalTo((UIScreen.main.bounds.size.width - 36) / 2)
            make.trailing.equalTo(safeAreaLayoutGuide).inset(12)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(postButton.snp.bottom).offset(8)
            make.horizontalEdges.bottom.equalTo(safeAreaLayoutGuide)
        }
    }
    
    override func configureView() {
        profileImage.backgroundColor = .systemPink
        profileName.backgroundColor = .orange
        postButton.backgroundColor = .blue
        scrapButton.backgroundColor = .yellow
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
