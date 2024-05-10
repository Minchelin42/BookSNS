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

    static let shared = MarketHomeViewModel()
    
    let updatePost = PublishSubject<Void>()
    
    init() {
        updatePost
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .flatMap { _ in
                return  NetworkManager.APIcall(type: GetPostModel.self, router: MarketRouter.getPost(next: ""))
                    .catch { error in
                        return Single<GetPostModel>.never()
                    }
            }
            .subscribe(onNext: { [weak self] postResult in
                self?.postResult.onNext(postResult.data)
            }, onError: { error in
                print("오류 발생: \(error)")
            })
            .disposed(by: disposeBag)
    }
    
    var disposeBag = DisposeBag()
    
    
    let postResult = PublishSubject<[PostModel]>()
    
    var next_cursor = ""
    var nowPostResult:[PostModel] = []
    
    struct Input {
        let getPost: PublishSubject<Void>
    }

    func transform(input: Input) {

        input.getPost
            .map { return self.next_cursor }
            .flatMap { next in
                return NetworkManager.APIcall(type: GetPostModel.self, router: MarketRouter.getPost(next: next))
                    .catch { error in
                        return Single<GetPostModel>.never()
                    }
            }
            .subscribe(with: self) { owner, postList in
                if owner.next_cursor.isEmpty {
                    owner.nowPostResult.removeAll()
                }
                if owner.next_cursor != "0" {
                    owner.nowPostResult.append(contentsOf: postList.data)
                    owner.postResult.onNext(owner.nowPostResult)
                    owner.next_cursor = postList.next_cursor
                }
            } onError: { owner, error in
                print("오류 발생 \(error)")
            }
            .disposed(by: disposeBag)
        
    }
}
