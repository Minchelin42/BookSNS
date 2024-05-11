//
//  CommentViewController.swift
//  BookSNS
//
//  Created by 민지은 on 2024/04/18.
//

import UIKit
import RxSwift
import RxCocoa
import Hero
import Kingfisher

class CommentViewController: RxBaseViewController, UIViewControllerTransitioningDelegate {
    
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
        
        output.commentRegisterSuccess
            .subscribe(with: self) { owner, _ in
                owner.mainView.textField.rx.text.onNext("")
            }
            .disposed(by: disposeBag)

        output.commentResult
            .bind(to: mainView.tableView.rx.items(
                cellIdentifier: CommentTableViewCell.identifier,
                cellType: CommentTableViewCell.self)
            ) {(row, element, cell) in
                cell.nickName.text = element.creator.nick
                cell.comment.text = element.content
                let url = URL(string: APIKey.baseURL.rawValue + "/" + element.creator.profileImage)!

                self.loadImage(loadURL: url, defaultImg: "defaultProfile") { resultImage in
                    cell.profileButton.setImage(resultImage, for: .normal)
                }
                

                cell.profileButton.rx.tap
                    .map { return element.creator.user_id }
                    .subscribe(with: self) { owner, profileID in
                        if profileID == UserDefaultsInfo.userID {
                            let vc = UINavigationController(rootViewController: ProfileViewController())
                            Transition.present(nowVC: owner, toVC: vc)
                        } else {
                            let vc = OtherProfileViewController()
                            vc.userID = profileID
                            let nav = UINavigationController(rootViewController: vc)
                            Transition.present(nowVC: owner, toVC: vc)
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
       
       let userID = UserDefaultsInfo.userID
       
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
