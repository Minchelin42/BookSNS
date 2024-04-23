//
//  SelectPostViewModel.swift
//  BookSNS
//
//  Created by 민지은 on 2024/04/20.
//

import Foundation
import RxSwift
import RxCocoa

class SelectPostViewModel: ViewModelType {
    
    var disposeBag = DisposeBag()
    
    struct Input {
        let loadPost: PublishSubject<String>
        let editButtonTapped: PublishSubject<String>
        let deleteButtonTapped: PublishSubject<String>
    }
    
    struct Output {
        let postResult: PublishSubject<PostModel>
        let editButtonTapped: PublishSubject<String>
        let deleteButtonTapped: PublishSubject<String>
    }
    
    func transform(input: Input) -> Output {
        
        let  postResult = PublishSubject<PostModel>()
        
        input.deleteButtonTapped
            .subscribe(with: self) { owner, id in
                NetworkManager.DeleteAPI(router: PostRouter.deletePost(id: id))
            }
            .disposed(by: disposeBag)
        
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
        
        return Output(postResult: postResult, editButtonTapped: input.editButtonTapped, deleteButtonTapped: input.deleteButtonTapped)
    }
    
}
