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
        
        viewModel.postID = self.postID
        
        wkWebView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }

    }
    
    override func bind() {
        let input = MarketSelectPostViewModel.Input(getProfile: PublishSubject<Void>(), loadPost: PublishSubject<String>(), editButtonTapped: PublishSubject<String>(), deleteButtonTapped: PublishSubject<String>())
        
        let output = viewModel.transform(input: input)
        
        output.editButtonTapped
            .subscribe(with: self) { owner, id in
               let vc = MarketPostViewController()
                vc.id = id
                vc.updatePost = {
                    input.loadPost.onNext(id)
                }
                Transition.push(nowVC: owner, toVC: vc)
            }
            .disposed(by: disposeBag)
        
        output.deleteButtonTapped
            .subscribe(with: self) { owner, _ in
                print("delete Button Clicked")
                
                owner.oneButtonAlert("삭제 완료") {
                    Transition.pop(owner)
                }
            }
            .disposed(by: disposeBag)
        
        output.isSoldOut
            .subscribe(with: self) { owner, value in
                owner.mainView.soldOutView.rx.isHidden.onNext(!value)
            }
            .disposed(by: disposeBag)
    
        output.postResult
            .subscribe(with: self) { owner, result in
                
                owner.viewModel.postResult = CreatePostQuery(content: result.content, content1: result.content1, content2: result.content2, content3: result.content3, content4: result.content4, content5: result.content5, files: result.files, product_id: result.product_id)
                
                owner.mainView.comment.rx.tap
                    .map { return result.post_id }
                    .subscribe(with: self) { owner, postID in
                        let vc = CommentViewController()
                        vc.post_id = postID
                        let nav = UINavigationController(rootViewController: vc)
                          if let sheet = nav.sheetPresentationController {
                              sheet.detents = [.medium(), .large()]
                              sheet.prefersGrabberVisible = true
                          }
                 
                        Transition.present(nowVC: owner, toVC: nav)
                    }
                    .disposed(by: owner.disposeBag)
                
                var isLike = result.likes.contains { $0 == UserDefaults.standard.string(forKey: "userID")}
                
                owner.mainView.save.setImage(UIImage(named: isLike ? "Bookmark.fill" : "Bookmark"), for: .normal)
                
                owner.mainView.save.rx.tap
                    .flatMap { _ in
                        return PostNetworkManager.like(id: owner.postID, query: LikeQuery(like_status: !isLike))
                    }
                    .subscribe(with: self) { owner, like in
                        isLike = like.like_status

                        owner.mainView.save.setImage(UIImage(named: isLike ? "Bookmark.fill" : "Bookmark"), for: .normal)
                        input.loadPost.onNext(owner.postID)
                    
                    } onError: { owner, error in
                        print("오류 발생 \(error)")
                    }
                    .disposed(by: owner.disposeBag)
                
                owner.mainView.nickName.rx.text.onNext("\(result.creator?.nick ?? "")님의 한마디")
                owner.mainView.userComment.rx.text.onNext(result.content)
                owner.mainView.bookTitleLabel.rx.text.onNext(result.content1)
                owner.mainView.standardPriceLabel.rx.text.onNext("정가: \(result.content2.makePrice)원")
                owner.mainView.marketPriceLabel.rx.text.onNext("중고 판매가: \(result.content4.makePrice)원")
                
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
                
                let profileImage = result.creator?.profileImage ?? ""

                let url = URL(string: APIKey.baseURL.rawValue + "/" + profileImage)!
    
                owner.loadImage(loadURL: url, defaultImg: "defaultProfile") { resultImage in
                    owner.mainView.profileButton.setImage(resultImage, for: .normal)
                }
                
                let isUser = (UserDefaults.standard.string(forKey: "userID") ?? "" == result.creator?.user_id)
                
                if isUser {
                    if result.likes2.isEmpty { //사용자의 게시글이며, 팔리지 않은 상품
                        owner.mainView.optionButton.isHidden = false

                    } else { //사용자의 게시글이며, 팔린 상품
                        owner.mainView.optionButton.isHidden = true
                    }
                } else { //사용자의 게시글이 X
                    owner.mainView.optionButton.isHidden = true
                }
         
                owner.mainView.profileButton.rx.tap
                    .map { return result.creator?.user_id ?? "" }
                    .subscribe(with: self) { owner, profileID in
                        
                        print("프로필버튼 구독⭐️")
                        
                        let userID = UserDefaults.standard.string(forKey: "userID") ?? ""
                        let isUser: Bool = ( profileID == userID )
                        
                        if isUser { //userID가 자신일 경우
                            let vc = ProfileViewController()
                            Transition.push(nowVC: owner, toVC: vc)
               
                        } else {
                            let vc = OtherProfileViewController()
                            vc.userID = profileID
                            Transition.push(nowVC: owner, toVC: vc)
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

                    let url = URL(string: APIKey.baseURL.rawValue + "/" + result.files[index])!

                    owner.loadImage(loadURL: url, defaultImg: "defaultProfile", completionHandler: { resultImage in
                        let image = UIImageView()
                        image.frame = CGRect(x: UIScreen.main.bounds.width * CGFloat(index), y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width * 0.9)
                        image.image = resultImage
                        owner.mainView.postImage.addSubview(image)
                    })

                    owner.mainView.postImage.contentSize.width = UIScreen.main.bounds.width * CGFloat(index + 1)

                }
                
                owner.mainView.postImage.rx.didEndDecelerating
                    .subscribe(with: self) { owner, _ in
                        let pageNumber = owner.mainView.postImage.contentOffset.x / UIScreen.main.bounds.width
                        owner.mainView.pageControl.currentPage = Int(pageNumber)
                    }
                    .disposed(by: owner.disposeBag)
                
                let edit = UIAction(title: "수정하기", image: UIImage(systemName: "pencil")) { action in
                    print("수정하기")
                    input.editButtonTapped.onNext(result.post_id)
                }
                let delete = UIAction(title: "삭제하기", image: UIImage(systemName: "trash"), attributes: .destructive) { action in
                    print("삭제하기")
                    input.deleteButtonTapped.onNext(result.post_id)
                    ProfileViewModel.shared.updateProfile.onNext(())
                }
                
                owner.mainView.optionButton.menu = UIMenu(options: .displayInline, children: [edit, delete])
                
                owner.mainView.linkButton.rx.tap
                    .subscribe(with: self) { owner, _ in
                        let vc = BookWebViewController()
                        vc.bookTitle = result.content1
                        vc.urlString = result.content3
                        Transition.push(nowVC: owner, toVC: vc)
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
        
        input.getProfile.onNext(())
        input.loadPost.onNext(postID)
    }

}



