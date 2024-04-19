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
        
        viewModel.post_id = self.post_id
        input.loadCommentResult.onNext(())
        
    }
    
}
