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
                print("postResult 시작", element.likes)
                cell.nickName.text = element.creator?.nick
                cell.textView.text = element.content1
                
                var isLike = element.likes.contains { $0 == "661e7154438b876b25f7566c"}
                
                cell.save.setImage(UIImage(named: isLike ? "Bookmark.fill" : "Bookmark"), for: .normal)
                
                cell.save.rx.tap
                    .flatMap { _ in

                        print("isLike: ",isLike)
                        
                        return PostNetworkManager.like(id: element.post_id, query: LikeQuery(like_status: !isLike))
                    }
                    .subscribe(with: self) { owner, like in
                        print("scrap button")
                        print("post_id: ", element.post_id)
                        print(like)
                        isLike = like.like_status
                        print("통신 이후 isLike", isLike)

                        cell.save.setImage(UIImage(named: isLike ? "Bookmark.fill" : "Bookmark"), for: .normal)
                        input.getPost.onNext(())
                        owner.mainView.tableView.reloadData()
                    
                    } onError: { owner, error in
                        print("오류 발생 \(error)")
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
