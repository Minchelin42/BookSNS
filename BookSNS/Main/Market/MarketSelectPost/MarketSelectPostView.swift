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
    
    let comment = UIButton()
    let save = UIButton()
    
    let optionButton = UIButton(type: .system)

    let bookTitleLabel = CustomLabel(size: 17, weight: .semibold, color: .black, text: "")
    let standardPriceLabel = CustomLabel(size: 15, weight: .medium, color: Color.pointColor!, text: "")
    let marketPriceLabel = CustomLabel(size: 16, weight: .semibold, color: .black, text: "")
    
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
    

    let profileButton = UIButton()
    
    let nickName = CustomLabel(size: 13, weight: .medium, color: .black, text: "")
    let userComment = CustomLabel(size: 13, weight: .medium, color: Color.mainColor!, text: "")

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
        contentView.addSubview(comment)
        contentView.addSubview(save)
        contentView.addSubview(optionButton)
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
        
        comment.snp.makeConstraints { make in
            make.leading.equalTo(contentView).inset(12)
            make.top.equalTo(postImage.snp.bottom).offset(8)
            make.size.equalTo(30)
        }
        
        save.snp.makeConstraints { make in
            make.trailing.equalTo(contentView).inset(12)
            make.top.equalTo(comment.snp.top)
            make.size.equalTo(30)
        }
        
        bookTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(comment.snp.bottom).offset(8)
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
            make.top.equalTo(nickName.snp.top).offset(-8)
            make.size.equalTo(30)
            make.trailing.equalTo(contentView).inset(12)
        }
        
        userComment.snp.makeConstraints { make in
            make.top.equalTo(nickName.snp.bottom)
            make.leading.equalTo(profileButton.snp.trailing).offset(12)
            make.trailing.equalTo(contentView).inset(20)
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
        
        profileButton.clipsToBounds = true
        profileButton.layer.cornerRadius = 40
        profileButton.layer.borderWidth = 1
        profileButton.layer.borderColor = Color.lightPoint?.cgColor
        
        
        pageControl.hidesForSinglePage = true
        pageControl.pageIndicatorTintColor = Color.lightPoint
        pageControl.currentPageIndicatorTintColor = Color.mainColor
        
        comment.setImage(UIImage(named: "Comment"), for: .normal)
        save.setImage(UIImage(named: "Bookmark"), for: .normal)

        optionButton.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        optionButton.tintColor = Color.mainColor
        optionButton.showsMenuAsPrimaryAction = true

        soldOutView.isHidden = true

    }
    
    func updateView(_ postModel: PostModel, isLike: Bool) {

        save.setImage(UIImage(named: isLike ? "Bookmark.fill" : "Bookmark"), for: .normal)
        
        userComment.text = postModel.content
        bookTitleLabel.text = postModel.content1
        standardPriceLabel.text = "정가: \(postModel.content2.makePrice)원"
        marketPriceLabel.text = "중고 판매가: \(postModel.content4.makePrice)원"
        
        nickName.text = "\(postModel.creator?.nick ?? "")님의 한마디"
        
        let profileImage = postModel.creator?.profileImage ?? ""

        MakeUI.loadImage(loadURL: MakeUI.makeURL(profileImage), defaultImg: "defaultProfile") { resultImage in
            self.profileButton.setImage(resultImage, for: .normal)
        }
        
        let isUser = UserClassification.isUser(compareID: postModel.creator?.user_id ?? "")
        
        if isUser {
            if postModel.likes2.isEmpty { //사용자의 게시글이며, 팔리지 않은 상품
                optionButton.isHidden = false

            } else { //사용자의 게시글이며, 팔린 상품
                optionButton.isHidden = true
            }
        } else { //사용자의 게시글이 X
            optionButton.isHidden = true
        }
        
        pageControl.numberOfPages = postModel.files.count
        
        for index in 0..<postModel.files.count {
            MakeUI.loadImage(loadURL: MakeUI.makeURL(postModel.files[index]), defaultImg: "defaultProfile", completionHandler: { resultImage in
                let image = UIImageView()
                image.frame = CGRect(x: UIScreen.main.bounds.width * CGFloat(index), y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width * 0.9)
                image.image = resultImage
                self.postImage.addSubview(image)
            })

            postImage.contentSize.width = UIScreen.main.bounds.width * CGFloat(index + 1)

        }
 
    }
    
    
}


#Preview {
    MarketSelectPostView()
}
