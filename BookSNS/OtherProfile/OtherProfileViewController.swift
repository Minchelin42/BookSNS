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
                owner.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)
        
        mainView.followerButton.rx.tap
            .subscribe(with: self) { owner, _ in
                let vc = FollowViewController()
                vc.userID = owner.userID
                vc.selectType = .follower
                owner.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)
        
        output.followList
            .subscribe(with: self) { owner, followingList in

                for index in 0..<followingList.count {
                    let following = followingList[index]
                    
                    if following.user_id == owner.userID {
                        isFollowing = true
                        break
                    } else {
                        isFollowing = false
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

                let modifier = AnyModifier { request in
                    var r = request
                    r.setValue(UserDefaults.standard.string(forKey: "accessToken"), forHTTPHeaderField: HTTPHeader.authorization.rawValue)
                    r.setValue(APIKey.sesacKey.rawValue, forHTTPHeaderField: HTTPHeader.sesacKey.rawValue)
                    return r
                }

                if !profile.profileImage.isEmpty {
                    let url = URL(string: APIKey.baseURL.rawValue + "/" + profile.profileImage)!
                    
                    owner.mainView.profileImage.kf.setImage(with: url, options: [.requestModifier(modifier)])
                } else {
                    owner.mainView.profileImage.image = UIImage(systemName: "person")
                }
            }
            .disposed(by: disposeBag)
        
        output.postResult
            .bind(to: mainView.collectionView.rx.items(cellIdentifier: PostCollectionViewCell.identifier, cellType: PostCollectionViewCell.self)
            ) { row, element, cell in
                
                NetworkManager.APIcall(type: PostModel.self, router: PostRouter.getThisPost(id: element)).subscribe(with: self) { owner, postModel in
                    
                    if postModel.product_id == "snapBook_market" {
                        cell.marketMark.isHidden = false
                    }

                    let modifier = AnyModifier { request in
                        var r = request
                        r.setValue(UserDefaults.standard.string(forKey: "accessToken"), forHTTPHeaderField: HTTPHeader.authorization.rawValue)
                        r.setValue(APIKey.sesacKey.rawValue, forHTTPHeaderField: HTTPHeader.sesacKey.rawValue)
                        return r
                    }

                    if !postModel.files.isEmpty {
                        let url = URL(string: APIKey.baseURL.rawValue + "/" + postModel.files[0])!
                        
                        cell.postImageView.kf.setImage(with: url, options: [.requestModifier(modifier)])
                    }
                }
                .disposed(by: self.disposeBag)

            }
            .disposed(by: disposeBag)
        
        self.mainView.collectionView.rx.modelSelected(String.self)
            .subscribe(with: self) { owner, postID in
                NetworkManager.APIcall(type: PostModel.self, router: PostRouter.getThisPost(id: postID)).subscribe(with: self) { owner, postModel in
                   
                    if postModel.product_id == "snapBook" {
                        let vc = SelectPostViewController()
                        vc.postID = postID
                        owner.navigationController?.pushViewController(vc, animated: true)
                    } else {
                        let vc = MarketSelectPostViewController()
                        vc.postID = postID
                        owner.navigationController?.pushViewController(vc, animated: true)
                    }
                }
                .disposed(by: owner.disposeBag)
            }
            .disposed(by: disposeBag)
        
        input.loadProfile.onNext(userID)
        input.getFollowingList.onNext(())
    }

}
