//
//  HomeViewModel.swift
//  BookSNS
//
//  Created by 민지은 on 2024/04/16.
//

import Foundation
import RxSwift
import RxCocoa

class HomeViewModel: ViewModelType {

    var disposeBag = DisposeBag()
    
    var userResult: ProfileModel? = nil
    
    struct Input {
        let getPost: PublishSubject<Void>
        let getProfile: PublishSubject<Void>
        let followButtonTapped: PublishSubject<String>
        let unfollowButtonTapped: PublishSubject<String>
        let editButtonTapped: PublishSubject<String>
        let deleteButtonTapped: PublishSubject<String>
    }
    
    struct Output {
        let postResult: PublishSubject<[PostModel]>
        let editButtonTapped: PublishSubject<String>
        let deleteButtonTapped: PublishSubject<String>
        let followingStatus: PublishSubject<Bool>
    }
    
    func transform(input: Input) -> Output{
        
        let postResult = PublishSubject<[PostModel]>()
        let followingStatus = PublishSubject<Bool>()
        
        input.getPost
            .flatMap { _ in
                return NetworkManager.APIcall(type: ProfileModel.self, router: ProfileRouter.myProfile)
            }
            .subscribe(with: self) { owner, profile in
                owner.userResult = profile
            }
            .disposed(by: disposeBag)
        
        input.followButtonTapped
            .flatMap { id in
                return NetworkManager.APIcall(type: SelectFollowModel.self, router: FollowRouter.follow(id: id))
            }
            .subscribe(with: self) { owner, _ in
                followingStatus.onNext(true)
            }
            .disposed(by: disposeBag)
        
        input.unfollowButtonTapped
            .subscribe(with: self) { owner, id in
                NetworkManager.DeleteAPI(router: FollowRouter.unfollow(id: id)) { value in
                    followingStatus.onNext(false)
                }
            }
            .disposed(by: disposeBag)
        
        input.deleteButtonTapped
            .subscribe(with: self) { owner, id in
                NetworkManager.DeleteAPI(router: PostRouter.deletePost(id: id)) { _ in }
                                         
                input.getPost.onNext(())
            }
            .disposed(by: disposeBag)
        
        input.getPost
            .flatMap { _ in
                return PostNetworkManager.getPost()
            }
            .subscribe(with: self) { owner, postList in
                print("getPost 구독 시작~")
                postResult.onNext(postList.data)
            } onError: { owner, error in
                print("오류 발생 \(error)")
            }
            .disposed(by: disposeBag)
        
        return Output(postResult: postResult, editButtonTapped: input.editButtonTapped, deleteButtonTapped: input.deleteButtonTapped, followingStatus: followingStatus)
    }
    
    func isUser(selectID: String, myID: String) -> Bool {
        if selectID == myID {
            print("사용자의 프로필 입니다")
            return true
        } else {
            print("다른 유저의 프로필 입니다")
            return false
        }
    }
    
}


