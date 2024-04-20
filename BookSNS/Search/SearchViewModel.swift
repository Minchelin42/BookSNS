//
//  SearchViewModel.swift
//  BookSNS
//
//  Created by 민지은 on 2024/04/20.
//

import Foundation
import RxSwift
import RxCocoa

class SearchViewModel: ViewModelType {
    
    var disposeBag = DisposeBag()
    
    struct Input {
        let getPost: PublishSubject<Void>
        let searchText: ControlProperty<String>
        let searchButtonClicked: ControlEvent<Void>
    }
    
    struct Output {
        let postResult: PublishSubject<[PostModel]>
    }
    
    func transform(input: Input) -> Output {
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
        
        input.searchText
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .flatMap { tag in
                if tag.isEmpty {
                    return PostNetworkManager.getPost()
                }
                return NetworkManager.APIcall(type: GetPostModel.self, router: PostRouter.hashTagPost(tag: tag))
            }
            .subscribe(with: self) { owner, postList in
                postResult.onNext(postList.data)
            } onError: { owner, error in
                print("오류 발생 \(error)")
            }
            .disposed(by: disposeBag)
        
        input.searchButtonClicked
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .withLatestFrom(input.searchText)
            .flatMap { tag in
                return NetworkManager.APIcall(type: GetPostModel.self, router: PostRouter.hashTagPost(tag: tag))
            }
            .subscribe(with: self) { owner, postList in
                postResult.onNext(postList.data)
            } onError: { owner, error in
                print("오류 발생 \(error)")
            }
            .disposed(by: disposeBag)
        
        return Output(postResult: postResult)
    }
    
    
}
