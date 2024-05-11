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
    
    let userID = UserDefaults.standard.string(forKey: "userID")
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
                
                owner.mainView.followButton.setTitle(owner.isFollowing ? "팔로잉" : "팔로우",  for: .normal)
                owner.mainView.followButton.backgroundColor = owner.isFollowing ? Color.mainColor : .white
                owner.mainView.followButton.setTitleColor(owner.isFollowing ? .white : Color.mainColor, for: .normal)
                
                let followMessage = status ? "팔로우를 시작합니다" : "팔로잉 취소되었습니다"
                
                owner.makeToast(followMessage)
            }
            .disposed(by: disposeBag)
        
        output.postResult
            .subscribe(with: self) { owner, result in
                owner.mainView.nickName.text = result.creator?.nick
                owner.mainView.textView.text = result.content
                
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
                
                let edit = UIAction(title: "수정하기", image: UIImage(systemName: "pencil")) { action in
                    print("수정하기")
                    input.editButtonTapped.onNext(result.post_id)
                }
                let delete = UIAction(title: "삭제하기", image: UIImage(systemName: "trash"), attributes: .destructive) { action in
                    print("삭제하기")
                    input.deleteButtonTapped.onNext(result.post_id)
                }
                
                owner.mainView.optionButton.isHidden = (owner.userID != result.creator?.user_id)
                owner.mainView.optionButton.menu = UIMenu(options: .displayInline, children: [edit, delete])
                
                owner.mainView.optionButton.isHidden = (owner.userID != result.creator?.user_id)
                owner.mainView.followButton.isHidden = (owner.userID == result.creator?.user_id)
  
                let userFollowing = owner.viewModel.userResult?.following ?? []
                
                for index in 0..<userFollowing.count {
                    let following = userFollowing[index]
                    
                    if following.user_id == result.creator?.user_id {
                        owner.isFollowing = true
                        break
                    }
                }
                
                owner.mainView.followButton.setTitle(owner.isFollowing ? "팔로잉" : "팔로우",  for: .normal)
                owner.mainView.followButton.backgroundColor = owner.isFollowing ? Color.mainColor : .white
                owner.mainView.followButton.setTitleColor(owner.isFollowing ? .white : Color.mainColor, for: .normal)
                
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

                owner.mainView.cardView.title.text = result.content1
                owner.mainView.cardView.price.text = "\(result.content2.makePrice)원"
                owner.mainView.cardView.bookImage.kf.setImage(with: URL(string: result.content4))
                
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
                
                owner.mainView.pageControl.numberOfPages = result.files.count
                
                owner.mainView.pageControl.rx.controlEvent(.valueChanged)
                    .map { return owner.mainView.pageControl.currentPage }
                    .subscribe(with: self) { owner, page in
                        owner.mainView.postImage.contentOffset.x = UIScreen.main.bounds.width * CGFloat(page)
                    }
                    .disposed(by: owner.disposeBag)
                
                for index in 0..<result.files.count {

                    let url = URL(string: APIKey.baseURL.rawValue + "/" + result.files[index])!
                    
                    owner.loadImage(loadURL: url, defaultImg: "defaultProfile") { resultImage in
                        let image = UIImageView()
                        image.frame = CGRect(x: UIScreen.main.bounds.width * CGFloat(index), y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width * 0.9)
                       
                        image.image = resultImage
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
    
        input.getProfile.onNext(())
        input.loadPost.onNext(postID)

    }
    

}
