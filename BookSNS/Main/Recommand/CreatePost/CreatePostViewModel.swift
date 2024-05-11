//
//  CreatePostViewModel.swift
//  BookSNS
//
//  Created by 민지은 on 2024/04/13.
//

import Foundation
import RxSwift
import RxCocoa
import UIKit

class CreatePostViewModel: ViewModelType {

    var disposeBag = DisposeBag()
    
    var imageData: [Data?] = []
    var inputImageData = PublishSubject<[Data?]>()
    var selectedBook = PublishSubject<BookModel>()
    var type: PostType = .create
    var id: String = ""
    
    struct Input {
        let contentText: ControlProperty<String>
        let imageData: PublishSubject<[Data?]>
        let fileData: PublishSubject<[String]>
        let imageRegisterButtonTapped: ControlEvent<Void>
        let searchBookButtonTapped: ControlEvent<Void>
        let createButtonTapped: ControlEvent<Void>
    }
    
    struct Output {
        let imageRegisterButtonTapped: Driver<Void>
        let searchBookButtonTapped: Driver<Void>
        let requiredMessage: PublishSubject<String>
        let createSuccesss: PublishSubject<Bool>
    }
    
    func transform(input: Input) -> Output {
        let createSuccess = PublishSubject<Bool>()
        var postQuery = CreatePostQuery(content: "", content1: "", content2: "", content3: "", content4: "", content5: "", files: [], product_id: "snapBook")
        let requiredMessage = PublishSubject<String>()
        
        input.contentText
            .subscribe(with: self) { owner, value in
                postQuery.content = value
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
            postQuery.content4 = book.cover
        }
        .disposed(by: disposeBag)

        input.createButtonTapped
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .flatMap { _ in
                if postValidation(query: postQuery) {
                    if self.type == .create {
                        return PostNetworkManager.createPost(query: postQuery)
                    } else {
                        return NetworkManager.APIcall(type: PostModel.self, router: PostRouter.editPost(id: self.id, query: postQuery))
                            .catch { error in
                                return Single<PostModel>.never()
                            }
                    }
                } else {
                    requiredMessage.onNext("게시글 내용을 체워주세요")
                    return Single<PostModel>.never()
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

        return Output(imageRegisterButtonTapped: input.imageRegisterButtonTapped.asDriver(), searchBookButtonTapped: input.searchBookButtonTapped.asDriver(), requiredMessage: requiredMessage, createSuccesss: createSuccess)
    }
    
}

func postValidation(query: CreatePostQuery) -> Bool {
    if query.files.isEmpty || query.content.isEmpty || query.content1.isEmpty || query.content2.isEmpty || query.content3.isEmpty || query.content4.isEmpty {
        return false
    } else { return true }
}
