//
//  ProfileViewModel.swift
//  BookSNS
//
//  Created by 민지은 on 2024/04/18.
//

import Foundation
import RxSwift
import RxCocoa

class ProfileViewModel: ViewModelType {
    
    var disposeBag = DisposeBag()
    
    static let shared = ProfileViewModel()
    
    let updateProfile = PublishSubject<Void>()
    let profileInfo = PublishSubject<ProfileModel>()
    let postResult = PublishSubject<[String]>()
    
    init() {
        updateProfile
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .flatMap { _ in
                return NetworkManager.APIcall(type: ProfileModel.self, router: ProfileRouter.myProfile)
                    .catch { error in
                        return Single<ProfileModel>.never()
                    }
            }
            .subscribe(onNext: { [weak self] profileResult in
                self?.profileInfo.onNext(profileResult)
                self?.postResult.onNext(profileResult.posts.reversed())
            }, onError: { error in
                print("오류 발생: \(error)")
            })
            .disposed(by: disposeBag)
    }

    struct Input {
        let loadProfile: PublishSubject<Void>
        let scrapButtonClicked: ControlEvent<Void>
        let postButtonClicked: ControlEvent<Void>
    }
    
    struct Output {
        let profileInfo: PublishSubject<ProfileModel>
        let postResult: PublishSubject<[String]>
        let selectPostButton: PublishSubject<Bool>
    }
    
    func transform(input: Input) -> Output {

        let selectPostButton = PublishSubject<Bool>()
        
        input.postButtonClicked
            .subscribe(with: self) { owner, scrapPost in
                input.loadProfile.onNext(())
                selectPostButton.onNext(true)
            }
            .disposed(by: disposeBag)
        
        input.scrapButtonClicked
            .flatMap { _ in
                return NetworkManager.APIcall(type: GetPostModel.self, router: ProfileRouter.getScraplist)
                    .catch { error in
                        return Single<GetPostModel>.never()
                    }
            }
            .subscribe(with: self) { owner, scrapPost in
                
                var scrapResult: [String] = []
                
                for index in 0..<scrapPost.data.count {
                    scrapResult.append(scrapPost.data[index].post_id)
                }
                
                owner.postResult.onNext(scrapResult)
                selectPostButton.onNext(false)
            }
            .disposed(by: disposeBag)
        
        input.loadProfile
            .flatMap { _ in
                return NetworkManager.APIcall(type: ProfileModel.self, router: ProfileRouter.myProfile)
                    .catch { error in
                        return Single<ProfileModel>.never()
                    }
            }
            .subscribe(with: self) { owner, profile in
                owner.profileInfo.onNext(profile)
                owner.postResult.onNext(profile.posts.reversed())
            }
            .disposed(by: disposeBag)
 
        return Output(profileInfo: self.profileInfo, postResult: self.postResult, selectPostButton: selectPostButton)
    }
    
}
