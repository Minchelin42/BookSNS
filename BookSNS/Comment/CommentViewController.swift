//
//  CommentViewController.swift
//  BookSNS
//
//  Created by 민지은 on 2024/04/18.
//

import UIKit
import RxSwift
import RxCocoa

class CommentViewController: RxBaseViewController {
    
    var post_id = ""
    
    let mainView = CommentView()
    let viewModel = CommentViewModel()
    
    override func loadView() {
        self.view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        mainView.tableView.register(CommentTableViewCell.self, forCellReuseIdentifier: CommentTableViewCell.identifier)
        mainView.tableView.rowHeight = UITableView.automaticDimension
    }
    
    override func bind() {
        
        let input = CommentViewModel.Input(loadCommentResult: PublishSubject<Void>(), commentText: mainView.textField.rx.text.orEmpty, registerButtonClicked: mainView.registerButton.rx.tap)
        
        let output = viewModel.transform(input: input)

        output.commentResult
            .bind(to: mainView.tableView.rx.items(
                cellIdentifier: CommentTableViewCell.identifier,
                cellType: CommentTableViewCell.self)
            ) {(row, element, cell) in
                cell.nickName.text = element.creator.nick
                cell.comment.text = element.content
            }
            .disposed(by: disposeBag)
        
        output.commentResult
            .subscribe(with: self) { owner, comment in
                owner.viewModel.commentResult = comment
            }
            .disposed(by: disposeBag)
        
        viewModel.deleteButtonTapped
            .subscribe(with: self) { owner, comment_id in
                NetworkManager.DeleteAPI(router: CommentRouter.deleteComment(id: owner.post_id, commentID: comment_id))
                input.loadCommentResult.onNext(())
            }
            .disposed(by: disposeBag)
        
        mainView.tableView.rx.setDelegate(self)
                    .disposed(by: disposeBag)

        viewModel.post_id = self.post_id
        input.loadCommentResult.onNext(())
        
    }
    
}

extension CommentViewController: UITableViewDelegate {

   func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
       
       let userID = UserDefaults.standard.string(forKey: "userID")
       
       if self.viewModel.commentResult[indexPath.row].creator.user_id == userID {
           
           let deleteButton = UITableViewRowAction(style: .default, title: "삭제") { (action, indexPath) in
               self.viewModel.deleteButtonTapped.onNext(self.viewModel.commentResult[indexPath.row].comment_id)
               print("delete")
               return
           }
           
           return [deleteButton]
           
       }

        return []
    }
}
