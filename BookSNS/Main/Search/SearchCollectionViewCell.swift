//
//  SearchCollectionViewCell.swift
//  BookSNS
//
//  Created by 민지은 on 2024/04/20.
//

import UIKit
import SnapKit

class SearchCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "SearchCollectionViewCell"
    
    let photoImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleToFill
        view.clipsToBounds = true
        
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        configureHierarchy()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureHierarchy() {
        contentView.addSubview(photoImageView)
    }
    
    private func configureLayout() {
        photoImageView.snp.makeConstraints { make in
            make.edges.equalTo(contentView)
        }
    }

}

