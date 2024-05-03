//
//  MarketSelectPostViewModel.swift
//  BookSNS
//
//  Created by 민지은 on 2024/05/02.
//

import Foundation
import RxSwift
import RxCocoa

class MarketSelectPostViewModel: ViewModelType {
    var disposeBag = DisposeBag()
    
    var userResult: ProfileModel? = nil
    
    var postID = ""
    
    var payQuery = PayQuery(imp_uid: "", post_id: "", productName: "", price: 0)
    var payValidation = PublishSubject<Void>()
    var saleComplete = PublishSubject<Void>()
    var postResult: CreatePostQuery!
    
    struct Input {
        let loadPost: PublishSubject<String>
    }
    
    struct Output {
        let postResult: PublishSubject<PostModel>
    }
    
    func transform(input: Input) -> Output {
        
        let postResult = PublishSubject<PostModel>()

        input.loadPost
            .flatMap { postID in
                return NetworkManager.APIcall(type: PostModel.self, router: PostRouter.getThisPost(id: postID))
            }
            .subscribe(with: self) { owner, post in
                postResult.onNext(post)
            } onError: { owner, error in
                print("오류 발생 \(error)")
            }
            .disposed(by: disposeBag)
        
        payValidation
            .flatMap { _ in
                return NetworkManager.APIcall(type: PayValidationModel.self, router: MarketRouter.payValidation(query: self.payQuery))
            }
            .subscribe(with: self) { owner, value in
                print(value)
                self.postResult.content5 = "true"
                owner.saleComplete.onNext(())
            }
            .disposed(by: disposeBag)
        
        saleComplete
            .flatMap{ _ in
                return NetworkManager.APIcall(type: PostModel.self, router: PostRouter.editPost(id: self.postID, query: self.postResult))
            }
            .subscribe(with: self) { owner, result in
                input.loadPost.onNext(owner.postID)
            } onError: { owner, error in
                print("오류 발생 \(error)")
            }
            .disposed(by: disposeBag)
        
        return Output(postResult: postResult)
    }
    
}
