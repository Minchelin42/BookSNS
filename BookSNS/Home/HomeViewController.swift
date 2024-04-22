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
    
    let userID = UserDefaults.standard.string(forKey: "userID") ?? ""
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.tableView.register(HomeTableViewCell.self, forCellReuseIdentifier: HomeTableViewCell.identifier)
        mainView.tableView.rowHeight = UITableView.automaticDimension
    }
    
    override func bind() {
        
        let input = HomeViewModel.Input(getPost: PublishSubject<Void>(), editButtonTapped: PublishSubject<String>(), deleteButtonTapped: PublishSubject<String>())
        let output = viewModel.transform(input: input)
        
        input.getPost.onNext(())
        
        output.editButtonTapped
            .subscribe(with: self) { owner, id in
               let vc = CreatePostViewController()
                vc.type = .edit
                vc.id = id
                owner.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)
        
        output.deleteButtonTapped
            .subscribe(with: self) { owenr, _ in
                print("delete Button Clicked")
            }
            .disposed(by: disposeBag)
        
        output.postResult
            .bind(to: mainView.tableView.rx.items(
                cellIdentifier: HomeTableViewCell.identifier,
                cellType: HomeTableViewCell.self)
            ) {(row, element, cell) in
                
                cell.nickName.text = element.creator?.nick
                cell.textView.text = element.content
                
                if let profileImage = element.creator?.profileImage {
                    if !profileImage.isEmpty {
                        let imgURL = URL(string: APIKey.baseURL.rawValue + "/" + profileImage)!
                        cell.profileButton.kf.setImage(with: imgURL, for: .normal)
                    } else {
                        cell.profileButton.setImage(UIImage(systemName: "person"), for: .normal)
                    }
                } else {
                    cell.profileButton.setImage(UIImage(systemName: "person"), for: .normal)
                }

                let edit = UIAction(title: "수정하기", image: UIImage(systemName: "pencil")) { action in
                    print("수정하기")
                    input.editButtonTapped.onNext(element.post_id)
                }
                let delete = UIAction(title: "삭제하기", image: UIImage(systemName: "trash"), attributes: .destructive) { action in
                    print("삭제하기")
                    input.deleteButtonTapped.onNext(element.post_id)
                }
                
                cell.optionButton.isHidden = (self.userID != element.creator?.user_id)

                cell.optionButton.menu = UIMenu(options: .displayInline, children: [edit, delete])
                
                cell.cardView.title.text = element.content1
                cell.cardView.price.text = "\(element.content2)원"
                cell.cardView.bookImage.kf.setImage(with: URL(string: element.content4))
                
                cell.tapGesture.rx.event
                    .subscribe(with: self) { owner, _ in
                        cell.cardView.unknownView.isHidden.toggle()
                        UIView.transition(with: cell.cardView, duration: 0.5, options: .transitionFlipFromTop, animations: nil, completion: nil)
                    }
                    .disposed(by: cell.disposeBag)
                
                var isLike = element.likes.contains { $0 == UserDefaults.standard.string(forKey: "userID")}
                
                cell.profileButton.rx.tap
                    .map { return element.creator?.user_id ?? "" }
                    .subscribe(with: self) { owner, profileID in

                        let isUser = owner.viewModel.isUser(selectID: profileID, myID: owner.userID)
                        
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
