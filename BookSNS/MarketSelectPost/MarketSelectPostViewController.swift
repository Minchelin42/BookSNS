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
import WebKit
import iamport_ios

class MarketSelectPostViewController: RxBaseViewController {
    
    let mainView = MarketSelectPostView()
    let viewModel = MarketSelectPostViewModel()
    
    lazy var wkWebView: WKWebView = {
        var view = WKWebView()
        view.backgroundColor = UIColor.clear
        view.isHidden = true
        return view
    }()
    
    var postID = ""
    
    override func loadView() {
        self.view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(wkWebView)
        
        wkWebView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }

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
                
                owner.viewModel.payQuery.post_id = owner.postID
                owner.viewModel.payQuery.price = Int(result.content4) ?? 0
                owner.viewModel.payQuery.productName = result.content1
                
                let payment = IamportPayment(
                    pg: PG.html5_inicis.makePgRawName(pgId: "INIpayTest"),
                    merchant_uid: "ios_\(APIKey.sesacKey.rawValue)_\(Int(Date().timeIntervalSince1970))",
                    amount: result.content4).then {
                        $0.pay_method = PayMethod.card.rawValue
                        $0.name = result.content1
                        $0.buyer_name = UserDefaults.standard.string(forKey: "nick")
                        $0.app_scheme = "sesac"
                    }
                
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
                
                owner.mainView.payButton.rx.tap
                    .subscribe(with: self) { owner, _ in
                        print("결제버튼 클릭")
                        owner.wkWebView.isHidden = false
                        Iamport.shared.paymentWebView(webViewMode: owner.wkWebView, userCode: APIKey.iamPortUserCode.rawValue, payment: payment) { [weak self] IamportResponse in
                            print(String(describing: IamportResponse))
                            owner.viewModel.payQuery.imp_uid = IamportResponse?.imp_uid ?? ""
                            print("imp_uid: ",IamportResponse?.imp_uid ?? "")
                            owner.viewModel.payValidation.onNext(())
                            owner.wkWebView.isHidden = true
                        }
                        
                    }
                    .disposed(by: owner.disposeBag)
                
            }
            .disposed(by: disposeBag)
        
    
        input.loadPost.onNext(postID)
    }

}
