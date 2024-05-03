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
    let marketMark = MarketMark(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
    
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
        contentView.addSubview(marketMark)
    }
    
    private func configureLayout() {
        postImageView.snp.makeConstraints { make in
            make.edges.equalTo(contentView)
        }
        
        marketMark.snp.makeConstraints { make in
            make.trailing.bottom.equalTo(contentView).inset(5)
            make.width.equalTo(35)
            make.height.equalTo(20)
        }
    }
    
    private func configureView() {
        marketMark.isHidden = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}
