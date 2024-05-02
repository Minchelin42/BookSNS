//
//  MarketHomeViewModel.swift
//  BookSNS
//
//  Created by 민지은 on 2024/05/02.
//

import Foundation
import RxSwift
import RxCocoa

class MarketHomeViewModel: ViewModelType {
    var disposeBag = DisposeBag()
    
    var next_cursor = ""
    var nowPostResult:[PostModel] = []
    
    struct Input {
        let getPost: PublishSubject<Void>
    }
    
    struct Output {
        let postResult: PublishSubject<[PostModel]>
    }
    
    func transform(input: Input) -> Output {
        let postResult = PublishSubject<[PostModel]>()

        input.getPost
            .map { return self.next_cursor }
            .flatMap { next in
                return NetworkManager.APIcall(type: GetPostModel.self, router: MarketRouter.getPost(next: next))
            }
            .subscribe(with: self) { owner, postList in
                if owner.next_cursor.isEmpty {
                    owner.nowPostResult.removeAll()
                }
                if owner.next_cursor != "0" {
                    owner.nowPostResult.append(contentsOf: postList.data)
                    postResult.onNext(owner.nowPostResult)
                    owner.next_cursor = postList.next_cursor
                }
            } onError: { owner, error in
                print("오류 발생 \(error)")
            }
            .disposed(by: disposeBag)
        
        return Output(postResult: postResult)
    }
}
