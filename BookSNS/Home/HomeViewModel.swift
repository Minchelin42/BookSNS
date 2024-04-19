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
    
    struct Input {
        let getPost: PublishSubject<Void>
    }
    
    struct Output {
        let postResult: PublishSubject<[PostModel]>
    }
    
    func transform(input: Input) -> Output{
        
        let postResult = PublishSubject<[PostModel]>()
        
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
        
        return Output(postResult: postResult)
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


