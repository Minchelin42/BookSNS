//
//  FollowListViewController.swift
//  BookSNS
//
//  Created by 민지은 on 2024/04/25.
//

import UIKit
import RxSwift
import RxCocoa
import Kingfisher

class FollowListViewController: RxBaseViewController {
    
    let mainView = FollowListView()
    let viewModel = FollowViewModel()
    
    var userID = ""
    
    var type: Follow = .following

    override func loadView() {
        self.view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        print("FollowListViewController init")
  
    }
    
    override func bind() {
        let input = FollowViewModel.Input(loadProfile: PublishSubject<Void>(), loadFollowList: PublishSubject<Void>(), loadFollowingList: PublishSubject<Void>(), followButtonTapped: PublishSubject<String>(), unfollowButtonTapped: PublishSubject<String>(), afterFollowButton: PublishSubject<Void>())
        
        let output = viewModel.transform(input: input)
        
        if self.type == .follower {
            
            viewModel.loadFollowList
                .bind(to: mainView.tableView.rx.items(
                    cellIdentifier: FollowListTableViewCell.identifier,
                    cellType: FollowListTableViewCell.self)
                ) {(row, element, cell) in
                    cell.nameLabel.text = element.nick
                    
                    cell.profileButton.rx.tap
                        .map { return element.user_id }
                        .subscribe(with: self) { owner, profileID in
                            if profileID == UserDefaultsInfo.userID {
                                let vc = ProfileViewController()
                                Transition.push(nowVC: owner, toVC: vc)
                            } else {
                                let vc = OtherProfileViewController()
                                vc.userID = profileID
                                Transition.push(nowVC: owner, toVC: vc)
                            }
                        }
                        .disposed(by: cell.disposeBag)
                    
                    let userFollowing = self.viewModel.profileInfo?.following ?? []
                    var isFollowing = UserClassification.isUserFollowing(followModel: userFollowing, id: element.user_id)

                    MakeUI.loadImage(loadURL: MakeUI.makeURL(element.profileImage), defaultImg: "defaultProfile") { resultImage in
                        cell.profileButton.setImage(resultImage, for: .normal)
                    }
                    let isUser = UserClassification.isUser(compareID: element.user_id)
                    if isUser {
                        cell.followButton.rx.isHidden.onNext(true)
                    }
                    
                    cell.followButton.setTitle(isFollowing ? "팔로잉" : "팔로우",  for: .normal)
                    cell.followButton.backgroundColor = isFollowing ? Color.mainColor : .white
                    cell.followButton.setTitleColor(isFollowing ? .white : Color.mainColor, for: .normal)
                    
                    cell.followButton.rx.tap
                        .map {
                            return element.user_id
                        }
                        .subscribe(with: self) { owner, profileID in
                            if !isFollowing {
                                input.followButtonTapped.onNext(profileID)
                            } else {
                                input.unfollowButtonTapped.onNext(profileID)
                            }
                        }
                        .disposed(by: cell.disposeBag)
                    
                }
                .disposed(by: disposeBag)
        } else {
            
            viewModel.loadFollowingList
                .bind(to: mainView.tableView.rx.items(
                    cellIdentifier: FollowListTableViewCell.identifier,
                    cellType: FollowListTableViewCell.self)
                ) {(row, element, cell) in
                    cell.nameLabel.text = element.nick
                    
                    cell.profileButton.rx.tap
                        .map { return element.user_id }
                        .subscribe(with: self) { owner, profileID in
                            if profileID == UserDefaultsInfo.userID {
                                let vc = ProfileViewController()
                                Transition.push(nowVC: owner, toVC: vc)
                            } else {
                                let vc = OtherProfileViewController()
                                vc.userID = profileID
                                Transition.push(nowVC: owner, toVC: vc)
                            }
                        }
                        .disposed(by: cell.disposeBag)
                    
                    let userFollowing = self.viewModel.profileInfo?.following ?? []
                    var isFollowing = UserClassification.isUserFollowing(followModel: userFollowing, id: element.user_id)

                    let isUser = UserClassification.isUser(compareID: element.user_id)
                    if isUser {
                        cell.followButton.rx.isHidden.onNext(true)
                    }

                    MakeUI.loadImage(loadURL: MakeUI.makeURL(element.profileImage), defaultImg: "defaultProfile") { resultImage in
                        cell.profileButton.setImage(resultImage, for: .normal)
                    }

                    cell.followButton.setTitle(isFollowing ? "팔로잉" : "팔로우",  for: .normal)
                    cell.followButton.backgroundColor = isFollowing ? Color.mainColor : .white
                    cell.followButton.setTitleColor(isFollowing ? .white : Color.mainColor, for: .normal)
                    
                    cell.followButton.rx.tap
                        .map {
                            return element.user_id
                        }
                        .subscribe(with: self) { owner, profileID in
                            print("작성자 ID:", element.user_id)
                            if !isFollowing {
                                input.followButtonTapped.onNext(profileID)
                            } else {
                                input.unfollowButtonTapped.onNext(profileID)
                            }
                        }
                        .disposed(by: cell.disposeBag)
                    
                }
                .disposed(by: disposeBag)
        }
        
        print(self.userID)
        viewModel.userID = self.userID
        viewModel.type = self.type

        input.loadProfile.onNext(())
        input.loadFollowList.onNext(())
        input.loadFollowingList.onNext(())

        
    }
    

}
