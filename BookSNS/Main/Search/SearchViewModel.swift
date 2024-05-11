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
    
    static let shared = SearchViewModel()
    
    var next_cursor = ""
    var search_cursor = ""
    var isSearch = false
    var nowPostResult:[PostModel] = []
    
    let updatePost = PublishSubject<Void>()
    let postResult = PublishSubject<[PostModel]>()
    
    init() {
        updatePost
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .flatMap { _ in
                return NetworkManager.APIcall(type: GetPostModel.self, router: PostRouter.getPost(next: ""))
                    .catch { error in
                        return Single<GetPostModel>.never()
                    }
            }
            .subscribe(onNext: { [weak self] getPostModel in
                self?.postResult.onNext(getPostModel.data)
            }, onError: { error in
                print("오류 발생: \(error)")
            })
            .disposed(by: disposeBag)
    }
    
    struct Input {
        let getPost: PublishSubject<Void>
        let getSearchPost: PublishSubject<Void>
        let searchText: PublishSubject<String>
        let searchButtonClicked: ControlEvent<Void>
    }
    
    struct Output {
        
    }
    
    func transform(input: Input) -> Output {

        input.getPost
            .map { return self.next_cursor }
            .flatMap { next in
                return NetworkManager.APIcall(type: GetPostModel.self, router: PostRouter.getPost(next: next))
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
                    .catch { error in
                        return Single<GetPostModel>.never()
                    }
            }
            .subscribe(with: self) { owner, postList in
                if owner.search_cursor != "0" {
                    owner.nowPostResult.append(contentsOf: postList.data)
                    owner.postResult.onNext(owner.nowPostResult)
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
                        .catch { error in
                            return Single<GetPostModel>.never()
                        }
                }
                self.isSearch = true
                return NetworkManager.APIcall(type: GetPostModel.self, router: PostRouter.hashTagPost(tag: tag, next: ""))
                    .catch { error in
                        return Single<GetPostModel>.never()
                    }
            }
            .subscribe(with: self) { owner, postList in
                print("searchText")
                owner.nowPostResult.removeAll()
                owner.nowPostResult.append(contentsOf: postList.data)
                owner.postResult.onNext(owner.nowPostResult)
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
                    .catch { error in
                        return Single<GetPostModel>.never()
                    }
            }
            .subscribe(with: self) { owner, postList in
                owner.isSearch = true
                owner.nowPostResult.removeAll()
                owner.nowPostResult.append(contentsOf: postList.data)
                owner.postResult.onNext(owner.nowPostResult)
                owner.search_cursor = postList.next_cursor
            } onError: { owner, error in
                print("오류 발생 \(error)")
            }
            .disposed(by: disposeBag)
        
        return Output()
    }
    
    
}
