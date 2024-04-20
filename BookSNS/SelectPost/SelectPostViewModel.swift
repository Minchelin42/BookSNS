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
    }
    
    struct Output {
        let postResult: PublishSubject<PostModel>
    }
    
    func transform(input: Input) -> Output {
        
        let  postResult = PublishSubject<PostModel>()
        
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
        
        return Output(postResult: postResult)
    }
    
}
