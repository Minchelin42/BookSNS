//
//  OtherProfileViewModel.swift
//  BookSNS
//
//  Created by 민지은 on 2024/04/20.
//

import Foundation
import RxSwift
import RxCocoa

class OtherProfileViewModel: ViewModelType {
    
    var disposeBag = DisposeBag()

    struct Input {
        let loadProfile: PublishSubject<String>
        let followButtonTapped: PublishSubject<String>
        let unfollowButtonTapped: PublishSubject<String>
        let getFollowingList: PublishSubject<Void>
    }
    
    struct Output {
        let profileInfo: PublishSubject<ProfileModel>
        let postResult: PublishSubject<[String]>
        let followList: PublishSubject<[FollowModel]>
    }
    
    func transform(input: Input) -> Output {
        
        let profileInfo = PublishSubject<ProfileModel>()
        let postResult = PublishSubject<[String]>()
        let followList = PublishSubject<[FollowModel]>()
        
        input.getFollowingList
            .flatMap { _ in
                return NetworkManager.APIcall(type: ProfileModel.self, router: ProfileRouter.myProfile)
            }
            .subscribe(with: self) { owner, profile in
                followList.onNext(profile.following)
            }
            .disposed(by: disposeBag)
        
        input.followButtonTapped
            .flatMap { id in
                return NetworkManager.APIcall(type: SelectFollowModel.self, router: FollowRouter.follow(id: id))
            }
            .subscribe(with: self) { owner, _ in
                print("팔로우 완")
                input.getFollowingList.onNext(())
            }
            .disposed(by: disposeBag)
        
        input.unfollowButtonTapped
            .subscribe(with: self) { owner, id in
                NetworkManager.DeleteAPI(router: FollowRouter.unfollow(id: id)) { value in
                    print("언팔로우 완")
                    input.getFollowingList.onNext(())
                }
            }
            .disposed(by: disposeBag)
        
        input.loadProfile
            .flatMap { userID in
                return NetworkManager.APIcall(type: ProfileModel.self, router: ProfileRouter.otherProfile(id: userID))
            }
            .subscribe(with: self) { owner, profile in
                profileInfo.onNext(profile)
                postResult.onNext(profile.posts.reversed())
            }
            .disposed(by: disposeBag)
        
        return Output(profileInfo: profileInfo, postResult: postResult, followList: followList)
    }
    
}

