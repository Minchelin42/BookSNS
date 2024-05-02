//
//  MarketSelectPostViewController.swift
//  BookSNS
//
//  Created by 민지은 on 2024/05/02.
//

import UIKit
import RxSwift
import RxCocoa
import Kingfisher
import Toast

class MarketSelectPostViewController: RxBaseViewController {
    
    let mainView = MarketSelectPostView()
    let viewModel = MarketSelectPostViewModel()
    
    var postID = ""
    
    override func loadView() {
        self.view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func bind() {
        let input = MarketSelectPostViewModel.Input(loadPost: PublishSubject<String>())
        
        let output = viewModel.transform(input: input)
    
        output.postResult
            .subscribe(with: self) { owner, result in
                owner.mainView.nickName.rx.text.onNext("\(result.creator?.nick ?? "")님의 한마디")
                owner.mainView.userComment.rx.text.onNext(result.content)
                owner.mainView.bookTitleLabel.rx.text.onNext(result.content1)
                owner.mainView.standardPriceLabel.rx.text.onNext("정가: \(result.content2)원")
                owner.mainView.marketPriceLabel.rx.text.onNext("중고 판매가: \(result.content4)원")
                
                if let profileImage = result.creator?.profileImage {
                    if !profileImage.isEmpty {
                        let imgURL = URL(string: APIKey.baseURL.rawValue + "/" + profileImage)!
                        owner.mainView.profileButton.kf.setImage(with: imgURL, for: .normal)
                    } else {
                        owner.mainView.profileButton.setImage(UIImage(named: "defaultProfile"), for: .normal)
                    }
                } else {
                    owner.mainView.profileButton.setImage(UIImage(named: "defaultProfile"), for: .normal)
                }
                
                owner.mainView.optionButton.isHidden = (UserDefaults.standard.string(forKey: "userID") ?? "" != result.creator?.user_id)

                owner.mainView.profileButton.rx.tap
                    .map { return result.creator?.user_id ?? "" }
                    .subscribe(with: self) { owner, profileID in
                        let userID = UserDefaults.standard.string(forKey: "userID") ?? ""
                        let isUser: Bool = ( profileID == userID )
                        
                        if isUser { //userID가 자신일 경우
                            let vc = ProfileViewController()
                            owner.navigationController?.pushViewController(vc, animated: true)
                        } else {
                            let vc = OtherProfileViewController()
                            vc.userID = profileID
                            owner.navigationController?.pushViewController(vc, animated: true)
                        }
                    }
                    .disposed(by: owner.disposeBag)

                owner.mainView.pageControl.numberOfPages = result.files.count
                
                owner.mainView.pageControl.rx.controlEvent(.valueChanged)
                    .map { return owner.mainView.pageControl.currentPage }
                    .subscribe(with: self) { owner, page in
                        owner.mainView.postImage.contentOffset.x = UIScreen.main.bounds.width * CGFloat(page)
                    }
                    .disposed(by: owner.disposeBag)
                
                for index in 0..<result.files.count {
                    
                    let image = UIImageView()
                    image.frame = CGRect(x: UIScreen.main.bounds.width * CGFloat(index), y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width * 0.9)
                    
                    let modifier = AnyModifier { request in
                        var r = request
                        r.setValue(UserDefaults.standard.string(forKey: "accessToken"), forHTTPHeaderField: HTTPHeader.authorization.rawValue)
                        r.setValue(APIKey.sesacKey.rawValue, forHTTPHeaderField: HTTPHeader.sesacKey.rawValue)
                        return r
                    }
                    
                    if !result.files.isEmpty {
                        let url = URL(string: APIKey.baseURL.rawValue + "/" + result.files[index])!

                        image.kf.setImage(with: url, options: [.requestModifier(modifier)])
                        
                        owner.mainView.postImage.addSubview(image)
                        
                        owner.mainView.postImage.contentSize.width = UIScreen.main.bounds.width * CGFloat(index + 1)

                    }
                }
                
                owner.mainView.postImage.rx.didEndDecelerating
                    .subscribe(with: self) { owner, _ in
                        let pageNumber = owner.mainView.postImage.contentOffset.x / UIScreen.main.bounds.width
                        owner.mainView.pageControl.currentPage = Int(pageNumber)
                    }
                    .disposed(by: owner.disposeBag)
                
            }
            .disposed(by: disposeBag)
    
        input.loadPost.onNext(postID)
    }

}
