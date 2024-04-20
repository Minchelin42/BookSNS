//
//  SelectPostViewController.swift
//  BookSNS
//
//  Created by 민지은 on 2024/04/20.
//

import UIKit
import RxSwift
import RxCocoa
import Kingfisher

class SelectPostViewController: RxBaseViewController {
    
    let mainView = SelectPostView()
    let viewModel = SelectPostViewModel()
    
    var postID = ""
    
    override func loadView() {
        self.view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func bind() {
        let input = SelectPostViewModel.Input(loadPost: PublishSubject<String>())
        
        let output = viewModel.transform(input: input)
        
        output.postResult
            .subscribe(with: self) { owner, result in
                owner.mainView.nickName.text = result.creator?.nick
                owner.mainView.textView.text = result.content1
                
                owner.mainView.comment.rx.tap
                    .map { return result.post_id }
                    .subscribe(with: self) { owner, postID in
                        let vc = CommentViewController()
                        vc.post_id = postID
                          if let sheet = vc.sheetPresentationController {
                              sheet.detents = [.medium()]
                              sheet.prefersGrabberVisible = true
                          }
                          
                          self.present(vc, animated: true)
                    }
                    .disposed(by: owner.disposeBag)
                
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
                
                let modifier = AnyModifier { request in
                    var r = request
                    r.setValue(UserDefaults.standard.string(forKey: "accessToken"), forHTTPHeaderField: HTTPHeader.authorization.rawValue)
                    r.setValue(APIKey.sesacKey.rawValue, forHTTPHeaderField: HTTPHeader.sesacKey.rawValue)
                    return r
                }
                
                if !result.files.isEmpty {
                    let url = URL(string: APIKey.baseURL.rawValue + "/" + result.files[0])!
                    
                    owner.mainView.postImage.kf.setImage(with: url, options: [.requestModifier(modifier)])
                }
                
            }
            .disposed(by: disposeBag)
        
        input.loadPost.onNext(postID)
    }
    

}
