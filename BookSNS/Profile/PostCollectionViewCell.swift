//
//  PostCollectionViewCell.swift
//  BookSNS
//
//  Created by 민지은 on 2024/04/18.
//

import UIKit
import SnapKit

class PostCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "PostCollectionViewCell"
    
    let postImageView = UIImageView()
    
    override func prepareForReuse() {
        postImageView.image = nil
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureHierarchy()
        configureLayout()
        configureView()
        
    }
    
    private func configureHierarchy() {
        contentView.addSubview(postImageView)
    }
    
    private func configureLayout() {
        postImageView.snp.makeConstraints { make in
            make.edges.equalTo(contentView)
        }
    }

    private func configureView() {
        postImageView.backgroundColor = .cyan
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}
