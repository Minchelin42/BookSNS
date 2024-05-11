//
//  HomeViewModel.swift
//  BookSNS
//
//  Created by 민지은 on 2024/04/16.
//

import UIKit
import RxSwift
import RxCocoa
import Foundation

struct Story {
    let title: String
    let searchType: String
}

class HomeViewModel: ViewModelType {
    
    static let shared = HomeViewModel()
    
    let updatePost = PublishSubject<Void>()
    let postResult = PublishSubject<[PostModel]>()
    
    init() {
        updatePost
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .flatMap { _ in
                return NetworkManager.APIcall(type: ProfileModel.self, router: ProfileRouter.myProfile)
                    .catch { error in
                        return Single<ProfileModel>.never()
                    }
            }
            .subscribe(onNext: { [weak self] userResult in
                self?.userResult = userResult
            }, onError: { error in
                print("오류 발생: \(error)")
            })
            .disposed(by: disposeBag)
        
        
        updatePost
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .flatMap { _ in
                return NetworkManager.APIcall(type: GetPostModel.self, router: PostRouter.getPost(next: ""))
                    .catch { error in
                        return Single<GetPostModel>.never()
                    }
            }
            .subscribe(onNext: { [weak self] getPostModel in
                self?.postResult.onNext(getPostModel.data)
            }, onError: { error in
                print("오류 발생: \(error)")
            })
            .disposed(by: disposeBag)
    }

    var disposeBag = DisposeBag()
    
    var next_cursor = ""
    var nowPostResult: [PostModel] = []
    
    var storyList = BehaviorSubject<[Story]>(value:[Story(title: "신간 TOP10", searchType: BookRankType.ItemNewSpecial.rawValue), Story(title: "편집자 TOP10", searchType: BookRankType.ItemEditorChoice.rawValue), Story(title: "베스트 TOP10", searchType: BookRankType.Bestseller.rawValue), Story(title: "블로거 TOP10", searchType: BookRankType.BlogBest.rawValue)])
    
    var userResult: ProfileModel? = nil
    
    struct Input {
        let getPost: PublishSubject<Void>
        let getProfile: PublishSubject<Void>
        let followButtonTapped: PublishSubject<String>
        let unfollowButtonTapped: PublishSubject<String>
        let editButtonTapped: PublishSubject<String>
        let deleteButtonTapped: PublishSubject<String>
        var storyButtonTapped: PublishSubject<Story>
    }
    
    struct Output {
        let editButtonTapped: PublishSubject<String>
        let deleteButtonTapped: PublishSubject<String>
        let followingStatus: PublishSubject<Bool>
        let storyButtonTapped: PublishSubject<Story>
    }
    
    func transform(input: Input) -> Output{
        let followingStatus = PublishSubject<Bool>()

        input.getPost
            .flatMap { _ in
                return NetworkManager.APIcall(type: ProfileModel.self, router: ProfileRouter.myProfile)
                    .catch { error in
                        return Single<ProfileModel>.never()
                    }
            }
            .subscribe(with: self) { owner, profile in
                owner.userResult = profile
            }
            .disposed(by: disposeBag)
        
        input.followButtonTapped
            .flatMap { id in
                return NetworkManager.APIcall(type: SelectFollowModel.self, router: FollowRouter.follow(id: id))
                    .catch { error in
                        return Single<SelectFollowModel>.never()
                    }
            }
            .subscribe(with: self) { owner, _ in
                owner.next_cursor = ""
                followingStatus.onNext(true)
                ProfileViewModel.shared.updateProfile.onNext(())
            }
            .disposed(by: disposeBag)
        
        input.unfollowButtonTapped
            .subscribe(with: self) { owner, id in
                NetworkManager.DeleteAPI(router: FollowRouter.unfollow(id: id)) { value in
                    owner.next_cursor = ""
                    followingStatus.onNext(false)
                    ProfileViewModel.shared.updateProfile.onNext(())
                }
            }
            .disposed(by: disposeBag)
        
        input.deleteButtonTapped
            .subscribe(with: self) { owner, id in
                NetworkManager.DeleteAPI(router: PostRouter.deletePost(id: id)) { _ in }
                owner.next_cursor = ""
            }
            .disposed(by: disposeBag)
        
        input.getPost
            .map { return self.next_cursor }
            .flatMap { next in
                return NetworkManager.APIcall(type: GetPostModel.self, router: PostRouter.getPost(next: next))
                    .catch { error in
                        return Single<GetPostModel>.never()
                    }
            }
            .subscribe(with: self) { owner, postList in
                if owner.next_cursor.isEmpty {
                    owner.nowPostResult = postList.data
                    owner.postResult.onNext(owner.nowPostResult)
                    owner.next_cursor = postList.next_cursor
                } else if owner.next_cursor != "0" {
                    owner.nowPostResult.append(contentsOf: postList.data)
                    owner.postResult.onNext(owner.nowPostResult)
                    owner.next_cursor = postList.next_cursor
                    print( owner.next_cursor)
                }

            } onError: { owner, error in
                print("오류 발생 \(error)")
            }
            .disposed(by: disposeBag)
        
        return Output(editButtonTapped: input.editButtonTapped, deleteButtonTapped: input.deleteButtonTapped, followingStatus: followingStatus, storyButtonTapped: input.storyButtonTapped)
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
    
    func isFollowing(creatorID: String) -> Bool {
        let userFollowing = userResult?.following ?? []
        
        for index in 0..<userFollowing.count {
            let following = userFollowing[index]
            if following.user_id == creatorID {
                return true
            }
        }
        
        return false
    }
}


