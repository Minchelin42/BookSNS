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
import Toast
import Hero

class HomeViewController: RxBaseViewController {

    let mainView = HomeView()
    let viewModel = HomeViewModel.shared
    
    var userID = UserDefaults.standard.string(forKey: "userID") ?? ""
   
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        customTitle()
        mainView.tableView.register(HomeTableViewCell.self, forCellReuseIdentifier: HomeTableViewCell.identifier)
        mainView.tableView.rowHeight = UITableView.automaticDimension
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.userID = UserDefaults.standard.string(forKey: "userID") ?? ""
    }
    
    override func bind() {
        
        let input = HomeViewModel.Input(getPost: PublishSubject<Void>(), getProfile: PublishSubject<Void>(), followButtonTapped: PublishSubject<String>(), unfollowButtonTapped: PublishSubject<String>(), editButtonTapped: PublishSubject<String>(), deleteButtonTapped: PublishSubject<String>())
        let output = viewModel.transform(input: input)
        
        input.getPost.onNext(())
        input.getProfile.onNext(())
        
        mainView.tableView.rx.didEndDragging
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .withLatestFrom(mainView.tableView.rx.contentOffset)
            .map { [weak self] contentOffset in
                guard let tableView = self?.mainView.tableView else { return false }
                return contentOffset.y + tableView.bounds.size.height >= tableView.contentSize.height
            }
            .subscribe(with: self) { owner, isScroll in
                if isScroll {
                    input.getPost.onNext(())
                }
            }
            .disposed(by: disposeBag)
        
        viewModel.storyList
            .bind(to: mainView.collectionView.rx.items(cellIdentifier: HomeCollectionViewCell.identifier, cellType: HomeCollectionViewCell.self)
            ) { row, element, cell in
                
                cell.storyButton.backgroundColor = Color.lightPoint
                cell.storyLabel.text = element.title
                
                cell.storyButton.rx.tap
                    .subscribe(with: self) { owner, _ in
                        let vc = StoryViewController()
                        vc.searchType = element.searchType
                        vc.rankTitle = element.title
                        
                        let nav = UINavigationController(rootViewController: vc)
                        nav.isHeroEnabled = true
                        nav.hero.modalAnimationType = .zoom
                        nav.modalPresentationStyle = .fullScreen
                        
                        owner.present(nav, animated: true)
                    }
                    .disposed(by: cell.disposeBag)
            }
            .disposed(by: disposeBag)
        
        output.editButtonTapped
            .subscribe(with: self) { owner, id in
               let vc = CreatePostViewController()
                vc.type = .edit
                vc.id = id
                vc.updatePost = {
                    input.getPost.onNext(())
                }
                owner.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)
        
        output.deleteButtonTapped
            .subscribe(with: self) { owenr, _ in
                print("delete Button Clicked")
            }
            .disposed(by: disposeBag)
        
        output.followingStatus
            .observe(on: MainScheduler.instance) 
            .subscribe(with: self) { owner, status in
                input.getPost.onNext(())
                var style = ToastStyle()

                style.messageColor = .white
                style.backgroundColor = Color.mainColor!
                style.messageFont = .systemFont(ofSize: 13, weight: .semibold)
                
                let followMessage = status ? "팔로우를 시작합니다" : "팔로잉 취소되었습니다"

                owner.view.makeToast(followMessage, duration: 0.5, position: .bottom, style: style)

            }
            .disposed(by: disposeBag)
        
        viewModel.postResult
            .bind(to: mainView.tableView.rx.items(
                cellIdentifier: HomeTableViewCell.identifier,
                cellType: HomeTableViewCell.self)
            ) {(row, element, cell) in
                print(row)
                cell.nickName.text = element.creator?.nick
                cell.textView.text = element.content
                
                let modifier = AnyModifier { request in
                    var r = request
                    r.setValue(UserDefaults.standard.string(forKey: "accessToken"), forHTTPHeaderField: HTTPHeader.authorization.rawValue)
                    r.setValue(APIKey.sesacKey.rawValue, forHTTPHeaderField: HTTPHeader.sesacKey.rawValue)
                    return r
                }
                
                let resultImage = UIImageView()
                
                let profileImage = element.creator?.profileImage ?? ""
                
                let imgURL = URL(string: APIKey.baseURL.rawValue + "/" + profileImage)!
                
                resultImage.kf.setImage(with: imgURL, options: [.requestModifier(modifier)], completionHandler: { result in
                    switch result {
                    case .success(let imageResult):
                        cell.profileButton.setImage(imageResult.image, for: .normal)
                    case .failure(let error):
                        print("이미지 로드 실패: \(error)")
                        //이미지 변환에 실패했을 때 defaultProfile
                        cell.profileButton.setImage(UIImage(named: "defaultProfile"), for: .normal)
                    }
                })
                

                let edit = UIAction(title: "수정하기", image: UIImage(systemName: "pencil")) { action in
                    print("수정하기")
                    input.editButtonTapped.onNext(element.post_id)
                }
                let delete = UIAction(title: "삭제하기", image: UIImage(systemName: "trash"), attributes: .destructive) { action in
                    print("삭제하기")
                    input.deleteButtonTapped.onNext(element.post_id)
                }
                
                cell.optionButton.isHidden = (self.userID != element.creator?.user_id)
                cell.followButton.isHidden = (self.userID == element.creator?.user_id)
                
                var isFollowing = false
                
                let userFollowing = self.viewModel.userResult?.following ?? []
                
                for index in 0..<userFollowing.count {
                    let following = userFollowing[index]
                    
                    if following.user_id == element.creator?.user_id {
                        isFollowing = true
                        break
                    }
                }
                
                cell.followButton.setTitle(isFollowing ? "팔로잉" : "팔로우",  for: .normal)
                cell.followButton.backgroundColor = isFollowing ? Color.mainColor : .white
                cell.followButton.setTitleColor(isFollowing ? .white : Color.mainColor, for: .normal)

                cell.optionButton.menu = UIMenu(options: .displayInline, children: [edit, delete])
                
                cell.cardView.title.text = element.content1
                cell.cardView.price.text = "\(element.content2.makePrice)원"
                cell.cardView.bookImage.kf.setImage(with: URL(string: element.content4))
                
                cell.cardView.linkButton.rx.tap
                    .subscribe(with: self) { owner, _ in
                        let vc = BookWebViewController()
                        vc.bookTitle = element.content1
                        vc.urlString = element.content3
                        owner.navigationController?.pushViewController(vc, animated: true)
                    }
                    .disposed(by: cell.disposeBag)
                
                cell.tapGesture.rx.event
                    .subscribe(with: self) { owner, _ in
                        cell.cardView.unknownView.isHidden.toggle()
                        UIView.transition(with: cell.cardView, duration: 0.5, options: .transitionFlipFromTop, animations: nil, completion: nil)
                    }
                    .disposed(by: cell.disposeBag)
                
                var isLike = element.likes.contains { $0 == UserDefaults.standard.string(forKey: "userID")}
                
                cell.followButton.rx.tap
                    .map { return element.creator?.user_id ?? "" }
                    .subscribe(with: self) { owner, profileID in
                        print("작성자 ID:", profileID)
                        if !isFollowing {
                            input.followButtonTapped.onNext(profileID)
                        } else {
                            input.unfollowButtonTapped.onNext(profileID)
                        }
                    }
                    .disposed(by: cell.disposeBag)
                
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
                        owner.viewModel.next_cursor = ""
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
                        let nav = UINavigationController(rootViewController: vc)
                          if let sheet = nav.sheetPresentationController {
                              sheet.detents = [.medium(), .large()]
                              sheet.prefersGrabberVisible = true
                          }
                    
                        self.present(nav, animated: true)
                    }
                    .disposed(by: cell.disposeBag)
                
                cell.pageControl.numberOfPages = element.files.count
                
                cell.pageControl.rx.controlEvent(.valueChanged)
                    .map { return cell.pageControl.currentPage }
                    .subscribe(with: self) { owner, page in
                        cell.postImage.contentOffset.x = UIScreen.main.bounds.width * CGFloat(page)
                    }
                    .disposed(by: cell.disposeBag)
                
                for index in 0..<element.files.count {
                    
                    let image = UIImageView()
                    image.frame = CGRect(x: UIScreen.main.bounds.width * CGFloat(index), y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width * 0.9)
                    
                    let modifier = AnyModifier { request in
                        var r = request
                        r.setValue(UserDefaults.standard.string(forKey: "accessToken"), forHTTPHeaderField: HTTPHeader.authorization.rawValue)
                        r.setValue(APIKey.sesacKey.rawValue, forHTTPHeaderField: HTTPHeader.sesacKey.rawValue)
                        return r
                    }
                    
                    if !element.files.isEmpty {
                        let url = URL(string: APIKey.baseURL.rawValue + "/" + element.files[index])!

                        image.kf.setImage(with: url, options: [.requestModifier(modifier)])
                        
                        cell.postImage.addSubview(image)
                        
                        cell.postImage.contentSize.width = UIScreen.main.bounds.width * CGFloat(index + 1)

                    }
                }
                
                cell.postImage.rx.didEndDecelerating
                    .subscribe(with: self) { owner, _ in
                        let pageNumber = cell.postImage.contentOffset.x / UIScreen.main.bounds.width
                        cell.pageControl.currentPage = Int(pageNumber)
                    }
                    .disposed(by: cell.disposeBag)

            }
            .disposed(by: disposeBag)
         
    }
    
}
