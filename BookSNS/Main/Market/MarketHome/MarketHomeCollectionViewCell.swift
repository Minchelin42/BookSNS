//
//  MarketHomeCollectionViewCell.swift
//  BookSNS
//
//  Created by 민지은 on 2024/05/02.
//

import UIKit
import SnapKit

class MarketHomeCollectionViewCell: UICollectionViewCell, CellType {

    let soldOutView = SoldOutView()
    
    let photoImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleToFill
        view.clipsToBounds = true
        
        return view
    }()

    let titleLabel = {
        let label = CustomLabel(size: 14, weight: .semibold, color: .black, text: "", alignment: .right)
        label.numberOfLines = 2
        return label
    }()

    let priceLabel = CustomLabel(size: 13, weight: .medium, color: .black, text: "", alignment: .right)
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        configureHierarchy()
        configureLayout()
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        soldOutView.isHidden = true
    }
    
    private func configureHierarchy() {
        contentView.addSubview(photoImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(soldOutView)
    }
    
    private func configureLayout() {
        photoImageView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(contentView).inset(4)
            make.bottom.equalTo(titleLabel.snp.top).offset(-4)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(contentView).inset(12)
            make.height.equalTo(20)
            make.bottom.equalTo(priceLabel.snp.top).offset(-4)
        }
        
        priceLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(contentView).inset(12)
            make.height.equalTo(14)
            make.bottom.equalTo(contentView).inset(4)
        }
        
        soldOutView.snp.makeConstraints { make in
            make.edges.equalTo(photoImageView)
        }
    }
    
    private func configureView() {

        photoImageView.clipsToBounds = true
        photoImageView.layer.cornerRadius = 20
        photoImageView.layer.borderWidth = 1
        photoImageView.layer.borderColor = Color.lightPoint?.cgColor
        
        soldOutView.isHidden = true
        soldOutView.clipsToBounds = true
        soldOutView.layer.cornerRadius = 20

        soldOutView.setLabelStyle(size: 30, weight: .bold)
    }

}

