//
//  OtherProfileViewController.swift
//  BookSNS
//
//  Created by 민지은 on 2024/04/20.
//

import UIKit
import RxSwift
import RxCocoa
import Kingfisher

class OtherProfileViewController: RxBaseViewController {
    
    let mainView = OtherProfileView()
    let viewModel = OtherProfileViewModel()
    
    var userID = ""
    
    override func loadView() {
        self.view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func bind() {
        let input = OtherProfileViewModel.Input(loadProfile: PublishSubject<String>(), followButtonTapped: PublishSubject<String>(), unfollowButtonTapped: PublishSubject<String>(), getFollowingList: PublishSubject<Void>())
        
        let output = viewModel.transform(input: input)
        
        var isFollowing = false

        mainView.followButton.rx.tap
            .subscribe(with: self) { owner, _ in
                print("Follow 버튼 클릭")
                if isFollowing {
                    input.unfollowButtonTapped.onNext(owner.userID)
                } else {
                    input.followButtonTapped.onNext(owner.userID)
                }
            }
            .disposed(by: disposeBag)
        
        mainView.followingButton.rx.tap
            .subscribe(with: self) { owner, _ in
                let vc = FollowViewController()
                vc.userID = owner.userID
                vc.selectType = .following
                Transition.push(nowVC: owner, toVC: vc)
            }
            .disposed(by: disposeBag)
        
        mainView.followerButton.rx.tap
            .subscribe(with: self) { owner, _ in
                let vc = FollowViewController()
                vc.userID = owner.userID
                vc.selectType = .follower
                Transition.push(nowVC: owner, toVC: vc)
            }
            .disposed(by: disposeBag)
        
        output.followList
            .subscribe(with: self) { owner, followingList in
                
                if followingList.isEmpty {
                    isFollowing = false
                } else {
                    for index in 0..<followingList.count {
                        let following = followingList[index]
                        
                        if following.user_id == owner.userID {
                            isFollowing = true
                            break
                        } else {
                            isFollowing = false
                        }
                    }
                }
                
                owner.mainView.followButton.setTitle(isFollowing ? "팔로잉" : "팔로우",  for: .normal)
                owner.mainView.followButton.backgroundColor = isFollowing ? Color.mainColor : .white
                owner.mainView.followButton.setTitleColor(isFollowing ? .white : Color.mainColor, for: .normal)
            }
            .disposed(by: disposeBag)
        
        output.profileInfo
            .subscribe(with: self) { owner, profile in
                
                owner.navigationItem.rx.title.onNext(profile.nick)
                
                owner.mainView.profileName.text = profile.nick
                owner.mainView.postNumLabel.text = "\(profile.posts.count)"
                owner.mainView.followerButton.setTitle("\(profile.followers.count)", for: .normal)
                owner.mainView.followingButton.setTitle("\(profile.following.count)", for: .normal)
 
                owner.loadImage(loadURL: owner.makeURL(profile.profileImage), defaultImg: "defaultProfile") { resultImage in
                    owner.mainView.profileImage.image = resultImage
                }
            }
            .disposed(by: disposeBag)
        
        output.postResult
            .bind(to: mainView.collectionView.rx.items(cellIdentifier: PostCollectionViewCell.identifier, cellType: PostCollectionViewCell.self)
            ) { row, element, cell in
                
                NetworkManager.APIcall(type: PostModel.self, router: PostRouter.getThisPost(id: element)) 
                    .catch { error in
                        return Single<PostModel>.never()
                    }
                    .subscribe(with: self) { owner, postModel in
                    
                        if postModel.product_id == "snapBook_market" {
                            cell.marketMark.isHidden = false
                        }

                        owner.loadImage(loadURL: owner.makeURL(postModel.files[0]), defaultImg: "defaultProfile") { resultImage in
                            cell.postImageView.image = resultImage
                        }

                }
                .disposed(by: self.disposeBag)

            }
            .disposed(by: disposeBag)
        
        self.mainView.collectionView.rx.modelSelected(String.self)
            .subscribe(with: self) { owner, postID in
                NetworkManager.APIcall(type: PostModel.self, router: PostRouter.getThisPost(id: postID))
                    .catch { error in
                        return Single<PostModel>.never()
                    }
                    .subscribe(with: self) { owner, postModel in
                   
                    if postModel.product_id == "snapBook" {
                        let vc = SelectPostViewController()
                        vc.postID = postID
                        Transition.push(nowVC: owner, toVC: vc)
                    } else {
                        let vc = MarketSelectPostViewController()
                        vc.postID = postID
                        Transition.push(nowVC: owner, toVC: vc)
                    }
                }
                .disposed(by: owner.disposeBag)
            }
            .disposed(by: disposeBag)
        
        input.loadProfile.onNext(userID)
        input.getFollowingList.onNext(())
    }

}
