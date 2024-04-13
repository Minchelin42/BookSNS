//
//  CreatePostViewModel.swift
//  BookSNS
//
//  Created by 민지은 on 2024/04/13.
//

import Foundation
import RxSwift
import RxCocoa

class CreatePostViewModel: ViewModelType {

    var disposeBag = DisposeBag()
    
    struct Input {
        let contentText: ControlProperty<String>
        let createButtonTapped: ControlEvent<Void>
    }
    
    struct Output {
        let createSuccesss: PublishSubject<Bool>
    }
    
    func transform(input: Input) -> Output {
        let createSuccess = PublishSubject<Bool>()
        
        let postQuery = input.contentText.map { text in
            CreatePostQuery(content: text, product_id: "test") }

        input.createButtonTapped
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .withLatestFrom(postQuery)
            .flatMap { postQuery in
                return PostNetworkManager.createPost(query: postQuery)
            }
            .subscribe(with: self) { owner, postModel in
                print(postModel)
                createSuccess.onNext(true)
            } onError: { owner, error in
                print("오류 발생 \(error)")
                createSuccess.onNext(false)
            }
            .disposed(by: disposeBag)

        return Output(createSuccesss: createSuccess)
    }
    
}
