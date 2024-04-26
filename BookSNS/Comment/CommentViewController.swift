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
        
        navigationItem.title = "댓글"
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: Color.mainColor]
        
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
                
                let profileImage = element.creator.profileImage
                    if !profileImage.isEmpty {
                        let imgURL = URL(string: APIKey.baseURL.rawValue + "/" + profileImage)!
                        cell.profileButton.kf.setImage(with: imgURL, for: .normal)
                    } else {
                        cell.profileButton.setImage(UIImage(named: "defaultProfile"), for: .normal)
                    }
                
                cell.profileButton.rx.tap
                    .map { return element.creator.user_id }
                    .subscribe(with: self) { owner, profileID in
                        if profileID == UserDefaults.standard.string(forKey: "userID") {
                            let vc = ProfileViewController()
                            owner.navigationController?.pushViewController(vc, animated: true)
                        } else {
                            let vc = OtherProfileViewController()
                            vc.userID = profileID
                            owner.navigationController?.pushViewController(vc, animated: true)
                        }
                    }
                    .disposed(by: cell.disposeBag)
                
            }
            .disposed(by: disposeBag)
        
        output.commentResult
            .subscribe(with: self) { owner, comment in
                owner.viewModel.commentResult = comment
            }
            .disposed(by: disposeBag)
        
        viewModel.deleteButtonTapped
            .subscribe(with: self) { owner, comment_id in
                NetworkManager.DeleteAPI(router: CommentRouter.deleteComment(id: owner.post_id, commentID: comment_id)) { _ in
                    print("댓글 삭제")
                }
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
