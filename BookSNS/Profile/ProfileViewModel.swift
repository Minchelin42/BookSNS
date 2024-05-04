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
        
        let profileInfo = PublishSubject<ProfileModel>()
        let postResult = PublishSubject<[String]>()
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
            }
            .subscribe(with: self) { owner, scrapPost in
                
                var scrapResult: [String] = []
                
                for index in 0..<scrapPost.data.count {
                    scrapResult.append(scrapPost.data[index].post_id)
                }
                
                postResult.onNext(scrapResult)
                selectPostButton.onNext(false)
            }
            .disposed(by: disposeBag)
        
        input.loadProfile
            .flatMap { _ in
                return NetworkManager.APIcall(type: ProfileModel.self, router: ProfileRouter.myProfile)
            }
            .subscribe(with: self) { owner, profile in
                profileInfo.onNext(profile)
                postResult.onNext(profile.posts.reversed())
            }
            .disposed(by: disposeBag)
 
        return Output(profileInfo: profileInfo, postResult: postResult, selectPostButton: selectPostButton)
    }
    
}
