//
//  MarketHomeCollectionViewCell.swift
//  BookSNS
//
//  Created by 민지은 on 2024/05/02.
//

import UIKit
import SnapKit

class MarketHomeCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "MarketHomeCollectionViewCell"
    
    let photoImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleToFill
        view.clipsToBounds = true
        
        return view
    }()
    
    let titleLabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        return label
    }()
    
    let priceLabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .medium)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        configureHierarchy()
        configureLayout()
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureHierarchy() {
        contentView.addSubview(photoImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(priceLabel)
    }
    
    private func configureLayout() {
        photoImageView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(contentView).inset(4)
            make.bottom.equalTo(titleLabel.snp.top).offset(-4)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(contentView).inset(12)
            make.height.greaterThanOrEqualTo(14)
            make.bottom.equalTo(priceLabel.snp.top).offset(-4)
        }
        
        priceLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(contentView).inset(12)
            make.height.equalTo(14)
            make.bottom.equalTo(contentView).inset(4)
        }
    }
    
    private func configureView() {
        
        titleLabel.numberOfLines = 2
        titleLabel.textAlignment = .right
        
        priceLabel.textAlignment = .right
        
        photoImageView.clipsToBounds = true
        photoImageView.layer.cornerRadius = 20
        photoImageView.layer.borderWidth = 1
        photoImageView.layer.borderColor = Color.lightPoint?.cgColor
    }

}

