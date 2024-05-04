//
//  MarketViewModel.swift
//  BookSNS
//
//  Created by 민지은 on 2024/05/02.
//

import Foundation
import RxSwift
import RxCocoa
import UIKit

class MarketPostViewModel: ViewModelType {

    var disposeBag = DisposeBag()
    
    var type: PostType = .create
    var editID = ""
    var postID = PublishSubject<String>()
    var postResult = PublishSubject<PostModel>()
    var imageData: [Data?] = []
    var inputImageData = PublishSubject<[Data?]>()
    var selectedBook = PublishSubject<BookModel>()
    
    struct Input {
        let contentText: ControlProperty<String> //판매자 한마디
        let priceText: ControlProperty<String> //가격
        let imageData: PublishSubject<[Data?]> //이미지
        let fileData: PublishSubject<[String]> //이미지 -> 문자열 변환
        let imageRegisterButtonTapped: ControlEvent<Void> //이미지 등록버튼
        let searchBookButtonTapped: ControlEvent<Void> //책 검색 버튼
        let createButtonTapped: ControlEvent<Void> //판매글 등록 버튼
    }
    
    struct Output {
        let imageRegisterButtonTapped: Driver<Void>
        let searchBookButtonTapped: Driver<Void>
        let createSuccesss: PublishSubject<Bool>
    }
    
    func transform(input: Input) -> Output {
        let createSuccess = PublishSubject<Bool>()
        var postQuery = CreatePostQuery(content: "", content1: "", content2: "", content3: "", content4: "", content5: "false", files: [], product_id: "snapBook_market")
        
        postID
            .flatMap { id in
                if !id.isEmpty { self.type = .edit }
                return NetworkManager.APIcall(type: PostModel.self, router: PostRouter.getThisPost(id: id))
            }.subscribe(with: self) { owner, post in
                owner.editID = post.post_id
                postQuery.content5 = post.content5
                owner.postResult.onNext(post)
            } onError: { owner, error in
                print("오류 발생 \(error)")
            }
            .disposed(by: disposeBag)
        
        input.contentText
            .subscribe(with: self) { owner, value in
                postQuery.content = value
            }
            .disposed(by: disposeBag)
        
        input.priceText
            .subscribe(with: self) { owner, value in
                postQuery.content4 = value
            }
            .disposed(by: disposeBag)
        
        input.imageData
            .flatMap { imageData in
                return PostNetworkManager.uploadImage(query: imageData)
            }
            .subscribe(with: self) { owner, fileModel in
                postQuery.files = fileModel.files
            } onError: { owner, error in
                print("오류 발생 \(error)")
                createSuccess.onNext(false)
            }
            .disposed(by: disposeBag)
        
        input.fileData
            .subscribe(with: self) { owner, files in
                postQuery.files = files
            } onError: { owner, error in
                print("오류 발생 \(error)")
                createSuccess.onNext(false)
            }
            .disposed(by: disposeBag)
        
        self.selectedBook.subscribe(with: self) { owner, book in
            postQuery.content1 = book.title
            postQuery.content2 = String(book.priceStandard)
            postQuery.content3 = book.link
        }
        .disposed(by: disposeBag)

        input.createButtonTapped
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .flatMap { _ in
                if self.type == .create {
                    return NetworkManager.APIcall(type: PostModel.self, router: MarketRouter.createPost(query: postQuery))
                } else {
                    return NetworkManager.APIcall(type: PostModel.self, router: PostRouter.editPost(id: self.editID, query: postQuery))
                }
            }
            .subscribe(with: self) { owner, postModel in
                print(postModel)
                createSuccess.onNext(true)
            } onError: { owner, error in
                print("오류 발생 \(error)")
                createSuccess.onNext(false)
            }
            .disposed(by: disposeBag)

        return Output(imageRegisterButtonTapped: input.imageRegisterButtonTapped.asDriver(), searchBookButtonTapped: input.searchBookButtonTapped.asDriver(), createSuccesss: createSuccess)
    }

}
