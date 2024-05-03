//
//  MarketSelectPostView.swift
//  BookSNS
//
//  Created by 민지은 on 2024/05/02.
//

import UIKit
import SnapKit

class MarketSelectPostView: BaseView {
    
    let scrollView = UIScrollView()
    let contentView = UIView()
    
    let soldOutView = SoldOutView()

    let postImage = UIScrollView()
    let pageControl = UIPageControl()
    
    let optionButton = UIButton(type: .system)
    
    let bookTitleLabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        return label
    }()
    
    let standardPriceLabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .medium)
        label.textColor = Color.pointColor
        return label
    }()
    
    let marketPriceLabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        return label
    }()
    
    let linkButton = {
        let button = UIButton()
        button.clipsToBounds = true
        button.layer.cornerRadius = 10
        button.layer.borderWidth = 1
        button.layer.borderColor = Color.mainColor?.cgColor
        button.setTitle("상세페이지", for: .normal)
        button.setTitleColor(Color.mainColor, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 13, weight: .medium)
        return button
    }()
    
    let grayView = {
       let view = UIView()
        view.backgroundColor = Color.mainColor?.withAlphaComponent(0.2)
       return view
    }()
    

    let profileButton = UIButton(type: .custom)
    let nickName = {
        let label = UILabel()
         label.font = .systemFont(ofSize: 13, weight: .medium)
        label.textColor = .black
         return label
    }()

    let userComment = {
        let label = UILabel()
         label.font = .systemFont(ofSize: 13, weight: .medium)
        label.textColor = Color.mainColor
        label.numberOfLines = 0
         return label
    }()

    let payButton = {
        let button = UIButton()
        button.backgroundColor = Color.mainColor
        button.setTitle("구매하기", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 15, weight: .semibold)
        button.setTitleColor(.white, for: .normal)
        button.clipsToBounds = true
        button.layer.cornerRadius = 11
        button.layer.borderWidth = 1
        button.layer.borderColor = Color.mainColor?.cgColor
        return button
    }()
    
    override func configureHierarchy() {
        
        addSubview(scrollView)
        scrollView.addSubview(contentView)

        contentView.addSubview(postImage)
        contentView.addSubview(optionButton)
        contentView.addSubview(pageControl)
        contentView.addSubview(bookTitleLabel)
        contentView.addSubview(standardPriceLabel)
        contentView.addSubview(marketPriceLabel)
        contentView.addSubview(linkButton)
        contentView.addSubview(grayView)
        contentView.addSubview(profileButton)
        contentView.addSubview(nickName)
        contentView.addSubview(userComment)
        contentView.addSubview(payButton)
        contentView.addSubview(soldOutView)
    }
    
    override func configureLayout() {
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide)
        }
        
        contentView.snp.makeConstraints { make in
            make.top.equalTo(scrollView.snp.top)
            make.bottom.equalTo(scrollView.snp.bottom)
            make.width.equalTo(scrollView.snp.width)
        }

        postImage.snp.makeConstraints { make in
            make.top.equalTo(contentView)
            make.horizontalEdges.equalTo(contentView)
            make.width.equalTo(UIScreen.main.bounds.width)
            make.height.equalTo(UIScreen.main.bounds.width * 0.9)
        }
        
        pageControl.snp.makeConstraints { make in
            make.centerX.equalTo(contentView)
            make.centerY.equalTo(postImage.snp.bottom).offset(8)
            make.height.equalTo(10)
        }
        
        bookTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(postImage.snp.bottom).offset(24)
            make.horizontalEdges.equalTo(contentView).inset(24)
            make.height.equalTo(22)
        }
        
        standardPriceLabel.snp.makeConstraints { make in
            make.top.equalTo(bookTitleLabel.snp.bottom).offset(4)
            make.leading.equalTo(contentView).inset(24)
            make.trailing.equalTo(marketPriceLabel.snp.trailing)
            make.height.equalTo(22)
        }
        
        marketPriceLabel.snp.makeConstraints { make in
            make.top.equalTo(standardPriceLabel.snp.bottom).offset(4)
            make.leading.equalTo(contentView).inset(24)
            make.trailing.equalTo(linkButton.snp.leading).offset(-12)
            make.height.equalTo(22)
        }
        
        linkButton.snp.makeConstraints { make in
            make.trailing.equalTo(contentView).inset(24)
            make.height.equalTo(33)
            make.width.equalTo(80)
            make.centerY.equalTo(marketPriceLabel)
        }
        
        grayView.snp.makeConstraints { make in
            make.top.equalTo(linkButton.snp.bottom).offset(20)
            make.height.equalTo(1)
            make.horizontalEdges.equalTo(contentView)
        }
        
        profileButton.snp.makeConstraints { make in
            make.top.equalTo(grayView.snp.bottom).offset(16)
            make.size.equalTo(80)
            make.leading.equalTo(contentView).inset(20)
        }
        
        nickName.snp.makeConstraints { make in
            make.top.equalTo(profileButton.snp.top).offset(4)
            make.leading.equalTo(profileButton.snp.trailing).offset(12)
            make.trailing.equalTo(optionButton.snp.leading).offset(-12)
            make.height.equalTo(22)
        }
        
        optionButton.snp.makeConstraints { make in
            make.top.equalTo(nickName.snp.top)
            make.size.equalTo(30)
            make.trailing.equalTo(contentView).inset(12)
        }
        
        userComment.snp.makeConstraints { make in
            make.top.equalTo(nickName.snp.bottom)
            make.leading.equalTo(profileButton.snp.trailing).offset(12)
            make.trailing.equalTo(contentView).inset(20)
//            make.height.greaterThanOrEqualTo(22)
            make.bottom.lessThanOrEqualTo(payButton.snp.top).offset(-16)
        }

        payButton.snp.makeConstraints { make in
            make.top.equalTo(profileButton.snp.bottom).offset(16)
            make.horizontalEdges.equalTo(contentView).inset(12)
            make.height.equalTo(45)
            make.bottom.equalTo(contentView).inset(8)
        }
        
        soldOutView.snp.makeConstraints { make in
            make.edges.equalTo(contentView)
        }
    }
    
    override func configureView() {

        postImage.isPagingEnabled = true
        postImage.showsHorizontalScrollIndicator = false
        postImage.backgroundColor = .yellow
//        optionButton.backgroundColor = .blue
        
        profileButton.clipsToBounds = true
        profileButton.layer.cornerRadius = 40
        
        pageControl.hidesForSinglePage = true
        pageControl.pageIndicatorTintColor = Color.lightPoint
        pageControl.currentPageIndicatorTintColor = Color.mainColor
        
//        bookTitleLabel.backgroundColor = .yellow
        bookTitleLabel.text = "이 불안에서 이불 안에서"
//        standardPriceLabel.backgroundColor = .blue
        standardPriceLabel.text = "정가: 12,800원"
//        marketPriceLabel.backgroundColor = .gray
        marketPriceLabel.text = "중고 판매가: 9,000원"
        
        optionButton.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        optionButton.tintColor = Color.mainColor
        optionButton.showsMenuAsPrimaryAction = true
        
        profileButton.backgroundColor = .orange
//        nickName.backgroundColor = .brown
        nickName.text = "min_wldms님의 한마디"
//        userComment.backgroundColor = .cyan
        userComment.text = "사놓고 한번 완독한 후 펼쳐보지 않아 새책입니다"
        
        soldOutView.isHidden = true

    }
    
    
}


