//
//  FollowViewModel.swift
//  BookSNS
//
//  Created by 민지은 on 2024/04/25.
//

import Foundation
import RxSwift
import RxCocoa
import UIKit

class FollowViewModel: ViewModelType {

    var disposeBag = DisposeBag()
    
    var userID = ""
    var type: Follow = .following
    
    var followList:[FollowModel] = []
    var followingList:[FollowModel] = []
    
    let loadFollowList = PublishSubject<[FollowModel]>()
    let loadFollowingList = PublishSubject<[FollowModel]>()
    
    var profileInfo: ProfileModel?

    struct Input {
        let loadProfile: PublishSubject<Void>
        let loadFollowList: PublishSubject<Void>
        let loadFollowingList: PublishSubject<Void>
        let followButtonTapped: PublishSubject<String>
        let unfollowButtonTapped: PublishSubject<String>
        let afterFollowButton: PublishSubject<Void>
    }
    
    struct Output {
    }
    
    func transform(input: Input) -> Output {
        
        input.followButtonTapped
            .flatMap { id in
                return NetworkManager.APIcall(type: SelectFollowModel.self, router: FollowRouter.follow(id: id))
                    .catch { error in
                        return Single<SelectFollowModel>.never()
                    }
            }
            .subscribe(with: self) { owner, _ in
                input.afterFollowButton.onNext(())
            }
            .disposed(by: disposeBag)
        
        input.unfollowButtonTapped
            .subscribe(with: self) { owner, id in
                NetworkManager.DeleteAPI(router: FollowRouter.unfollow(id: id)) { _ in
                    input.afterFollowButton.onNext(())
                }
            }
            .disposed(by: disposeBag)
        
        input.loadProfile
            .map { return self.userID }
            .flatMap { userID in
                return NetworkManager.APIcall(type: ProfileModel.self, router: ProfileRouter.otherProfile(id: userID))
                    .catch { error in
                        return Single<ProfileModel>.never()
                    }
            }
            .subscribe(with: self) { owner, profile in
                owner.profileInfo = profile
                owner.followList = profile.followers
                owner.followingList = profile.following
                if owner.type == .following {
                    owner.loadFollowingList.onNext(profile.following)
                } else {
                    owner.loadFollowList.onNext(profile.followers)
                }
            }
            .disposed(by: disposeBag)
        
        input.afterFollowButton
            .map { return UserDefaults.standard.string(forKey: "userID") ?? "" }
            .flatMap { userID in
                return NetworkManager.APIcall(type: ProfileModel.self, router: ProfileRouter.otherProfile(id: userID))
                    .catch { error in
                        return Single<ProfileModel>.never()
                    }
            }
            .subscribe(with: self) { owner, profile in
                owner.profileInfo = profile
                if owner.type == .following {
                    owner.loadFollowingList.onNext(owner.followingList)
                } else {
                    owner.loadFollowList.onNext(owner.followList)
                }
            }
            .disposed(by: disposeBag)

        return Output()
    }
    
}
