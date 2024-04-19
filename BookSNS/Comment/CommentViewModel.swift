//
//  CommentViewModel.swift
//  BookSNS
//
//  Created by 민지은 on 2024/04/18.
//

import Foundation
import RxSwift
import RxCocoa

class CommentViewModel: ViewModelType {
    
    var disposeBag = DisposeBag()

    var post_id: String = ""
    
    struct Input {
        let loadCommentResult: PublishSubject<Void>
        let commentText: ControlProperty<String>
        let registerButtonClicked: ControlEvent<Void>
    }
    
    struct Output {
        let commentResult: PublishSubject<[CommentModel]>
    }
    
    func transform(input: Input) -> Output {
        
        let commentResult = PublishSubject<[CommentModel]>()
        
        var commentQuery = CreateCommentQuery(content: "")
        
        input.loadCommentResult
            .flatMap { _ in
                return NetworkManager.APIcall(type: PostModel.self, router: PostRouter.getThisPost(id: self.post_id))
            }
            .subscribe(with: self) { owner, postList in
                commentResult.onNext(postList.comments)
            } onError: { owner, error in
                print("오류 발생 \(error)")
            }
            .disposed(by: disposeBag)
        
        input.commentText
            .subscribe(with: self) { owner, value in
                commentQuery.content = value
            }
            .disposed(by: disposeBag)
            
        
        input.registerButtonClicked
            .flatMap { comment in
                return NetworkManager.APIcall(type: CommentModel.self, router: CommentRouter.createComment(id: self.post_id, query: commentQuery))
            }
            .subscribe(with: self) { owner, comment in
                print("등록된 댓글", comment)
                input.loadCommentResult.onNext(())
            } onError: { owner, error in
                print("오류 발생 \(error)")
            }
            .disposed(by: disposeBag)
        
        return Output(commentResult: commentResult)
    }
    
    
}
