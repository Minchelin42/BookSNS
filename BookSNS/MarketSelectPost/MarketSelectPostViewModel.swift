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
        let getProfile: PublishSubject<Void>
        let loadPost: PublishSubject<String>
        let editButtonTapped: PublishSubject<String>
        let deleteButtonTapped: PublishSubject<String>
    }
    
    struct Output {
        let postResult: PublishSubject<PostModel>
        let editButtonTapped: PublishSubject<String>
        let deleteButtonTapped: PublishSubject<String>
        let isSoldOut: PublishSubject<Bool>
    }
    
    func transform(input: Input) -> Output {
        
        let postResult = PublishSubject<PostModel>()
        let isSoldOut = PublishSubject<Bool>()
        
        input.getProfile
            .flatMap { _ in
                return NetworkManager.APIcall(type: ProfileModel.self, router: ProfileRouter.myProfile)
            }
            .subscribe(with: self) { owner, profile in
                owner.userResult = profile
            }
            .disposed(by: disposeBag)
        
        input.deleteButtonTapped
            .subscribe(with: self) { owner, id in
                NetworkManager.DeleteAPI(router: PostRouter.deletePost(id: id)) { _ in }
            }
            .disposed(by: disposeBag)

        input.loadPost
            .flatMap { postID in
                return NetworkManager.APIcall(type: PostModel.self, router: PostRouter.getThisPost(id: postID))
            }
            .subscribe(with: self) { owner, post in
                postResult.onNext(post)
                
                if post.likes2.count != 0 {
                    isSoldOut.onNext(true)
                } else {
                    isSoldOut.onNext(false)
                }
                
            } onError: { owner, error in
                print("오류 발생 \(error)")
            }
            .disposed(by: disposeBag)
        
        payValidation
            .flatMap { _ in
                return NetworkManager.APIcall(type: PayValidationModel.self, router: MarketRouter.payValidation(query: self.payQuery))
            }
            .subscribe(with: self) { owner, value in
                self.postResult.content5 = "true"
                owner.saleComplete.onNext(())
            }
            .disposed(by: disposeBag)
        
        saleComplete
            .map { return self.postID }
            .flatMap { id in
                return NetworkManager.APIcall(type: LikeModel.self, router: PostRouter.like2(id: id, query: LikeQuery(like_status: true)))
            }
            .subscribe(with: self) { owner, result in
                input.loadPost.onNext(owner.postID)
            } onError: { owner, error in
                print("오류 발생 \(error)")
            }
            .disposed(by: disposeBag)
        
        return Output(postResult: postResult, editButtonTapped: input.editButtonTapped, deleteButtonTapped: input.deleteButtonTapped, isSoldOut: isSoldOut)
    }
    
}
