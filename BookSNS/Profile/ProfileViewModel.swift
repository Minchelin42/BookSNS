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
    }
    
    struct Output {
        let profileInfo: PublishSubject<ProfileModel>
        let postResult: PublishSubject<[String]>
    }
    
    func transform(input: Input) -> Output {
        
        let profileInfo = PublishSubject<ProfileModel>()
        let postResult = PublishSubject<[String]>()
        
        input.loadProfile
            .flatMap { _ in
                return NetworkManager.APIcall(type: ProfileModel.self, router: ProfileRouter.myProfile)
            }
            .subscribe(with: self) { owner, profile in
                profileInfo.onNext(profile)
                postResult.onNext(profile.posts.reversed())
            }
            .disposed(by: disposeBag)
 
        return Output(profileInfo: profileInfo, postResult: postResult)
    }
    
}
