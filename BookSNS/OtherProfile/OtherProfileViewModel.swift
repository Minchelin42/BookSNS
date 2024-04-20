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
    }
    
    struct Output {
        let profileInfo: PublishSubject<ProfileModel>
        let postResult: PublishSubject<[String]>
    }
    
    func transform(input: Input) -> Output {
        
        let profileInfo = PublishSubject<ProfileModel>()
        let postResult = PublishSubject<[String]>()
        
        input.loadProfile
            .flatMap { userID in
                return NetworkManager.APIcall(type: ProfileModel.self, router: ProfileRouter.otherProfile(id: userID))
            }
            .subscribe(with: self) { owner, profile in
                profileInfo.onNext(profile)
                postResult.onNext(profile.posts.reversed())
            }
            .disposed(by: disposeBag)
        
        
        return Output(profileInfo: profileInfo, postResult: postResult)
    }
    
}

