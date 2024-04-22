//
//  EditProfileViewModel.swift
//  BookSNS
//
//  Created by 민지은 on 2024/04/22.
//

import Foundation
import RxSwift
import RxCocoa

class EditProfileViewModel: ViewModelType {
    
    var disposeBag = DisposeBag()
    
    let nickName = PublishSubject<String>()
    let profileImage = PublishSubject<String>()
    
    
    struct Input {
        let nickNameText: ControlProperty<String>
        let editImageButtonTapped: ControlEvent<Void>
        let editButtonTapped: PublishSubject<ProfileQuery>
    }
    
    struct Output {

        let editProfileSuccess: PublishSubject<Bool>
    }

    func transform(input: Input) -> Output {
        
        let nick = UserDefaults.standard.value(forKey: "nick")
        let profileImage = UserDefaults.standard.value(forKey: "profileImage")
        let editProfileSuccess = PublishSubject<Bool>()
        
        input.editButtonTapped
            .flatMap { profileQuery in
                return NetworkManager.uploadProfile(query: profileQuery)
            }
            .subscribe(with: self) { owner, profileModel in
                print(profileModel)
                UserDefaults.standard.setValue(profileModel.nick, forKey: "nick")
                UserDefaults.standard.setValue(profileModel.profileImage, forKey: "profileImage")
                editProfileSuccess.onNext(true)
            } onError: { owner, error in
                print("오류 발생 \(error)")
                editProfileSuccess.onNext(false)
            }
            .disposed(by: disposeBag)
        
        
        return Output(editProfileSuccess: editProfileSuccess)
    }
    
}
