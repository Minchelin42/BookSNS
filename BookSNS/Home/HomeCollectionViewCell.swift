//
//  HomeCollectionViewCell.swift
//  BookSNS
//
//  Created by 민지은 on 2024/04/28.
//

import UIKit
import SnapKit
import RxSwift

class HomeCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "HomeCollectionViewCell"
    var disposeBag = DisposeBag()
    
    let storyButton = {
        let button = UIButton()
        button.clipsToBounds = true
        button.setImage(UIImage(named: "Books"), for: .normal)
        button.layer.cornerRadius = ((UIScreen.main.bounds.width - 100) / 4) / 2
        button.layer.borderWidth = 3
        button.layer.borderColor = Color.pointColor?.cgColor
        return button
    }()

    let storyLabel = CustomLabel(size: 12, weight: .medium, color: .black, text: "", alignment: .center)

    override init(frame: CGRect) {
        super.init(frame: frame)

        configureHierarchy()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureHierarchy() {
        contentView.addSubview(storyButton)
        contentView.addSubview(storyLabel)
    }
    
    private func configureLayout() {
        storyButton.snp.makeConstraints { make in
            make.size.equalTo((UIScreen.main.bounds.width - 100) / 4)
            make.top.equalTo(contentView)
        }
        
        storyLabel.snp.makeConstraints { make in
            make.height.equalTo(12)
            make.width.equalTo((UIScreen.main.bounds.width - 100) / 4)
            make.top.equalTo(storyButton.snp.bottom).offset(8)
        }
    }

}


