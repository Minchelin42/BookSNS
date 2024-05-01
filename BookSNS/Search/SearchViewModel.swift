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
    
    var next_cursor = ""
    var search_cursor = ""
    var isSearch = false
    var nowPostResult:[PostModel] = []
    
    struct Input {
        let getPost: PublishSubject<Void>
        let getSearchPost: PublishSubject<Void>
        let searchText: PublishSubject<String>
        let searchButtonClicked: ControlEvent<Void>
    }
    
    struct Output {
        let postResult: PublishSubject<[PostModel]>
    }
    
    func transform(input: Input) -> Output {
        let postResult = PublishSubject<[PostModel]>()

        input.getPost
            .map { return self.next_cursor }
            .flatMap { next in
                return NetworkManager.APIcall(type: GetPostModel.self, router: PostRouter.getPost(next: next))
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
        
        input.getSearchPost
            .map { _ in
                var inputText = ""
                input.searchText.subscribe(with: self) { owner, tag in
                    inputText = tag
                }
                .disposed(by: self.disposeBag)
                return inputText
            }
            .flatMap { tag in
                return  NetworkManager.APIcall(type: GetPostModel.self, router: PostRouter.hashTagPost(tag: tag, next: self.search_cursor))
            }
            .subscribe(with: self) { owner, postList in
                if owner.search_cursor != "0" {
                    owner.nowPostResult.append(contentsOf: postList.data)
                    postResult.onNext(owner.nowPostResult)
                    owner.search_cursor = postList.next_cursor
                }
            } onError: { owner, error in
                print("오류 발생 \(error)")
            }
            .disposed(by: disposeBag)
        
        
        input.searchText
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .flatMap { tag in
                if tag.isEmpty {
                    self.isSearch = false
                    self.nowPostResult.removeAll()
                    self.next_cursor = ""
                    return NetworkManager.APIcall(type: GetPostModel.self, router: PostRouter.getPost(next: ""))
                }
                self.isSearch = true
                return NetworkManager.APIcall(type: GetPostModel.self, router: PostRouter.hashTagPost(tag: tag, next: ""))
            }
            .subscribe(with: self) { owner, postList in
                print("searchText")
                owner.nowPostResult.removeAll()
                owner.nowPostResult.append(contentsOf: postList.data)
                postResult.onNext(owner.nowPostResult)
                owner.next_cursor = postList.next_cursor
                owner.search_cursor = postList.next_cursor
            } onError: { owner, error in
                print("오류 발생 \(error)")
            }
            .disposed(by: disposeBag)
        
        input.searchButtonClicked
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .withLatestFrom(input.searchText)
            .flatMap { tag in
                return NetworkManager.APIcall(type: GetPostModel.self, router: PostRouter.hashTagPost(tag: tag, next: self.search_cursor))
            }
            .subscribe(with: self) { owner, postList in
                owner.isSearch = true
                owner.nowPostResult.removeAll()
                owner.nowPostResult.append(contentsOf: postList.data)
                postResult.onNext(owner.nowPostResult)
                owner.search_cursor = postList.next_cursor
            } onError: { owner, error in
                print("오류 발생 \(error)")
            }
            .disposed(by: disposeBag)
        
        return Output(postResult: postResult)
    }
    
    
}
