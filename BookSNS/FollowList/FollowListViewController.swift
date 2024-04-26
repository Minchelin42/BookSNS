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
                            if profileID == UserDefaults.standard.string(forKey: "userID") {
                                let vc = ProfileViewController()
                                owner.navigationController?.pushViewController(vc, animated: true)
                            } else {
                                let vc = OtherProfileViewController()
                                vc.userID = profileID
                                owner.navigationController?.pushViewController(vc, animated: true)
                            }
                        }
                        .disposed(by: cell.disposeBag)
                    
                    var isFollowing = false
                    
                    let image = UIImageView()
                    
                    let modifier = AnyModifier { request in
                        var r = request
                        r.setValue(UserDefaults.standard.string(forKey: "accessToken"), forHTTPHeaderField: HTTPHeader.authorization.rawValue)
                        r.setValue(APIKey.sesacKey.rawValue, forHTTPHeaderField: HTTPHeader.sesacKey.rawValue)
                        return r
                    }
                    
                    if !element.profileImage.isEmpty {
                        let url = URL(string: APIKey.baseURL.rawValue + "/" + element.profileImage)!

                        image.kf.setImage(with: url, options: [.requestModifier(modifier)])
                        
                        cell.profileButton.setImage(image.image, for: .normal)
                    }
                    
                    let userFollowing = self.viewModel.profileInfo?.following ?? []
                    
                    for index in 0..<userFollowing.count {
                        let following = userFollowing[index]
                        
                        if following.user_id == element.user_id {
                            isFollowing = true
                            break
                        }
                    }
                    
                    if element.user_id == (UserDefaults.standard.string(forKey: "userID") ?? "") {
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
                            if profileID == UserDefaults.standard.string(forKey: "userID") {
                                let vc = ProfileViewController()
                                owner.navigationController?.pushViewController(vc, animated: true)
                            } else {
                                let vc = OtherProfileViewController()
                                vc.userID = profileID
                                owner.navigationController?.pushViewController(vc, animated: true)
                            }
                        }
                        .disposed(by: cell.disposeBag)
                    
                    var isFollowing = false
                    
                    let image = UIImageView()
                    
                    let modifier = AnyModifier { request in
                        var r = request
                        r.setValue(UserDefaults.standard.string(forKey: "accessToken"), forHTTPHeaderField: HTTPHeader.authorization.rawValue)
                        r.setValue(APIKey.sesacKey.rawValue, forHTTPHeaderField: HTTPHeader.sesacKey.rawValue)
                        return r
                    }
                    
                    if !element.profileImage.isEmpty {
                        let url = URL(string: APIKey.baseURL.rawValue + "/" + element.profileImage)!

                        image.kf.setImage(with: url, options: [.requestModifier(modifier)])
                        
                        cell.profileButton.setImage(image.image, for: .normal)
                    }
 
                    let userFollowing = self.viewModel.profileInfo?.following ?? []
                    
                    for index in 0..<userFollowing.count {
                        let following = userFollowing[index]
                        
                        if following.user_id == element.user_id {
                            isFollowing = true
                            break
                        } else {
                            isFollowing = false
                        }
                    }
                    
                    if element.user_id == (UserDefaults.standard.string(forKey: "userID") ?? "") {
                        print("이거 되고있나;", element.nick)
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
