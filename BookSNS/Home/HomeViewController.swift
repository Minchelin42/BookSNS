//
//  GetPostViewController.swift
//  BookSNS
//
//  Created by 민지은 on 2024/04/16.
//

import UIKit
import RxSwift
import RxCocoa
import Kingfisher

class HomeViewController: RxBaseViewController {

    let mainView = HomeView()
    let viewModel = HomeViewModel()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.tableView.register(HomeTableViewCell.self, forCellReuseIdentifier: HomeTableViewCell.identifier)
        mainView.tableView.rowHeight = UITableView.automaticDimension
    }
    
    override func bind() {
        
        let input = HomeViewModel.Input(getPost: PublishSubject<Void>())
        let output = viewModel.transform(input: input)
        
        input.getPost.onNext(())

        output.postResult
            .bind(to: mainView.tableView.rx.items(
                cellIdentifier: HomeTableViewCell.identifier,
                cellType: HomeTableViewCell.self)
            ) {(row, element, cell) in
                
                cell.nickName.text = element.creator?.nick
                cell.textView.text = element.content1
                
                var isLike = element.likes.contains { $0 == UserDefaults.standard.string(forKey: "userID")}
                
                cell.profileButton.rx.tap
                    .map { return element.creator?.user_id ?? "" }
                    .subscribe(with: self) { owner, profileID in
                        let userID = UserDefaults.standard.string(forKey: "userID") ?? ""
                        let isUser = owner.viewModel.isUser(selectID: profileID, myID: userID)
                        
                        if isUser { //userID가 자신일 경우
                            let vc = ProfileViewController()
                            owner.navigationController?.pushViewController(vc, animated: true)
                        } else {
                            let vc = OtherProfileViewController()
                            vc.userID = profileID
                            owner.navigationController?.pushViewController(vc, animated: true)
                        }
                    }
                    .disposed(by: cell.disposeBag)
                
                cell.save.setImage(UIImage(named: isLike ? "Bookmark.fill" : "Bookmark"), for: .normal)
                
                cell.save.rx.tap
                    .flatMap { _ in
                        return PostNetworkManager.like(id: element.post_id, query: LikeQuery(like_status: !isLike))
                    }
                    .subscribe(with: self) { owner, like in
                        isLike = like.like_status

                        cell.save.setImage(UIImage(named: isLike ? "Bookmark.fill" : "Bookmark"), for: .normal)
                        input.getPost.onNext(())
                        owner.mainView.tableView.reloadData()
                    
                    } onError: { owner, error in
                        print("오류 발생 \(error)")
                    }
                    .disposed(by: cell.disposeBag)
  
                cell.comment.rx.tap
                    .subscribe(with: self) { owner, _ in
                        let vc = CommentViewController()
                        vc.post_id = element.post_id
                          if let sheet = vc.sheetPresentationController {
                              sheet.detents = [.medium()]

                              sheet.prefersGrabberVisible = true
                          }
                          
                          self.present(vc, animated: true)
                    }
                    .disposed(by: cell.disposeBag)
                
                let modifier = AnyModifier { request in
                    var r = request
                    r.setValue(UserDefaults.standard.string(forKey: "accessToken"), forHTTPHeaderField: HTTPHeader.authorization.rawValue)
                    r.setValue(APIKey.sesacKey.rawValue, forHTTPHeaderField: HTTPHeader.sesacKey.rawValue)
                    return r
                }
                
                if !element.files.isEmpty {
                    let url = URL(string: APIKey.baseURL.rawValue + "/" + element.files[0])!
                    
                    cell.postImage.kf.setImage(with: url, options: [.requestModifier(modifier)])
                }
            }
            .disposed(by: disposeBag)
         
    }
    
}
