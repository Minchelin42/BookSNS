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
    
    let userID = UserDefaultsInfo.userID
    var isFollowing = false
    
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
        let input = SelectPostViewModel.Input(loadPost: PublishSubject<String>(), getProfile: PublishSubject<Void>(), followButtonTapped: PublishSubject<String>(), unfollowButtonTapped: PublishSubject<String>(), editButtonTapped: PublishSubject<String>(), deleteButtonTapped: PublishSubject<String>())
        
        let output = viewModel.transform(input: input)
        
        output.editButtonTapped
            .subscribe(with: self) { owner, id in
               let vc = CreatePostViewController()
                vc.type = .edit
                vc.id = id
                vc.updatePost = {
                    input.loadPost.onNext(id)
                }
                Transition.push(nowVC: owner, toVC: vc)
            }
            .disposed(by: disposeBag)
        
        output.deleteButtonTapped
            .subscribe(with: self) { owner, _ in
                owner.oneButtonAlert("삭제 완료") {
                    Transition.pop(owner)
                }
            }
            .disposed(by: disposeBag)
        
        output.followingStatus
            .observe(on: MainScheduler.instance)
            .subscribe(with: self) { owner, status in
                
                owner.isFollowing = status
                owner.mainView.updateFollowButton(isFollowing: owner.isFollowing)
                
                let followMessage = status ? "팔로우를 시작합니다" : "팔로잉 취소되었습니다"
                owner.makeToast(followMessage)
            }
            .disposed(by: disposeBag)
        
        output.postResult
            .subscribe(with: self) { owner, result in

                let isUser = UserClassification.isUser(compareID: result.creator?.user_id ?? "")
                var isLike = UserClassification.isUserLike(likes: result.likes)
                owner.isFollowing = UserClassification.isUserFollowing(followModel: owner.viewModel.userResult?.following ?? [], id: result.creator?.user_id ?? "")
  
                owner.mainView.updateView(result, isLike: isLike, isUser: isUser)
                owner.mainView.updateFollowButton(isFollowing: owner.isFollowing)
                
                let edit = UIAction(title: "수정하기", image: UIImage(systemName: "pencil")) { action in
                    print("수정하기")
                    input.editButtonTapped.onNext(result.post_id)
                }
                let delete = UIAction(title: "삭제하기", image: UIImage(systemName: "trash"), attributes: .destructive) { action in
                    print("삭제하기")
                    input.deleteButtonTapped.onNext(result.post_id)
                }

                owner.mainView.optionButton.menu = UIMenu(options: .displayInline, children: [edit, delete])

                owner.mainView.followButton.rx.tap
                    .map { return result.creator?.user_id ?? "" }
                    .subscribe(with: self) { owner, profileID in
                        print("작성자 ID:", profileID)
                        if !owner.isFollowing {
                            input.followButtonTapped.onNext(profileID)
                        } else {
                            input.unfollowButtonTapped.onNext(profileID)
                        }
                    }
                    .disposed(by: owner.disposeBag)
 
                owner.mainView.tapGesture.rx.event
                    .subscribe(with: self) { owner, _ in
                        owner.mainView.cardView.unknownView.isHidden.toggle()
                        UIView.transition(with:  owner.mainView.cardView, duration: 0.5, options: .transitionFlipFromTop, animations: nil, completion: nil)
                    }
                    .disposed(by: owner.disposeBag)
                
                owner.mainView.comment.rx.tap
                    .map { return result.post_id }
                    .subscribe(with: self) { owner, postID in
                        let vc = CommentViewController()
                        vc.post_id = postID
                        Transition.sheet(nowVC: owner, toVC: vc)
                    }
                    .disposed(by: owner.disposeBag)
                
                owner.mainView.profileButton.rx.tap
                    .map { return result.creator?.user_id ?? "" }
                    .subscribe(with: self) { owner, profileID in
                        let userID = UserDefaultsInfo.userID
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

                owner.mainView.pageControl.rx.controlEvent(.valueChanged)
                    .map { return owner.mainView.pageControl.currentPage }
                    .subscribe(with: self) { owner, page in
                        owner.mainView.postImage.contentOffset.x = UIScreen.main.bounds.width * CGFloat(page)
                    }
                    .disposed(by: owner.disposeBag)

                owner.mainView.postImage.rx.didEndDecelerating
                    .subscribe(with: self) { owner, _ in
                        let pageNumber = owner.mainView.postImage.contentOffset.x / UIScreen.main.bounds.width
                        owner.mainView.pageControl.currentPage = Int(pageNumber)
                    }
                    .disposed(by: owner.disposeBag)
                
            }
            .disposed(by: disposeBag)
    
        input.getProfile.onNext(())
        input.loadPost.onNext(postID)

    }
    

}
