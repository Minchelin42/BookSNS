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
import Hero

class HomeViewController: RxBaseViewController {

    let mainView = HomeView()
    let viewModel = HomeViewModel.shared
    var userID = UserDefaultsInfo.userID
    
    
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
        self.userID = UserDefaultsInfo.userID
    }
    
    override func bind() {
        
        var input = HomeViewModel.Input(getPost: PublishSubject<Void>(), getProfile: PublishSubject<Void>(), followButtonTapped: PublishSubject<String>(), unfollowButtonTapped: PublishSubject<String>(), editButtonTapped: PublishSubject<String>(), deleteButtonTapped: PublishSubject<String>(), storyButtonTapped: PublishSubject<Story>())
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
                    .map { element }
                    .subscribe(with: self) { owner, story in
                        input.storyButtonTapped.onNext(story)
                    }
                    .disposed(by: cell.disposeBag)
  
            }
            .disposed(by: disposeBag)
        
        output.storyButtonTapped
            .subscribe(with: self) { owner, story in
                let vc = StoryViewController()
                vc.searchType = story.searchType
                vc.rankTitle = story.title
                
                let nav = UINavigationController(rootViewController: vc)
                nav.isHeroEnabled = true
                nav.hero.modalAnimationType = .autoReverse(presenting: .zoom)
                nav.modalPresentationStyle = .fullScreen
                
                Transition.present(nowVC: owner, toVC: nav)
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
                Transition.push(nowVC: owner, toVC: vc)
            }
            .disposed(by: disposeBag)
        
        output.deleteButtonTapped
            .subscribe(with: self) { owner, _ in
                print("delete Button Clicked")
                owner.oneButtonAlert("삭제 완료") { input.getPost.onNext(()) }
            }
            .disposed(by: disposeBag)
        
        output.followingStatus
            .observe(on: MainScheduler.instance) 
            .subscribe(with: self) { owner, status in
                input.getPost.onNext(())
                let followMessage = status ? "팔로우를 시작합니다" : "팔로잉 취소되었습니다"
                owner.makeToast(followMessage)

            }
            .disposed(by: disposeBag)
        
        viewModel.postResult
            .bind(to: mainView.tableView.rx.items(
                cellIdentifier: HomeTableViewCell.identifier,
                cellType: HomeTableViewCell.self)
            ) { [weak self] (row, element, cell) in
                guard let self else { return }
                
                var isLike = UserClassification.isUserLike(likes: element.likes)
                let creatorID = element.creator?.user_id ?? ""
                let isFollowing = self.viewModel.isFollowing(creatorID: creatorID)
                cell.updateCell(element, isLike: isLike, isFollowing: isFollowing)

                let edit = UIAction(title: "수정하기", image: UIImage(systemName: "pencil")) { action in
                    print("수정하기")
                    input.editButtonTapped.onNext(element.post_id)
                }
                let delete = UIAction(title: "삭제하기", image: UIImage(systemName: "trash"), attributes: .destructive) { action in
                    print("삭제하기")
                    input.deleteButtonTapped.onNext(element.post_id)
                }
                cell.optionButton.menu = UIMenu(options: .displayInline, children: [edit, delete])
                
                cell.cardView.linkButton.rx.tap
                    .subscribe(with: self) { owner, _ in
                        let vc = BookWebViewController()
                        vc.bookTitle = element.content1
                        vc.urlString = element.content3
                        Transition.push(nowVC: owner, toVC: vc)
                    }
                    .disposed(by: cell.disposeBag)
                
                cell.tapGesture.rx.event
                    .subscribe(with: self) { owner, _ in
                        cell.cardView.unknownView.isHidden.toggle()
                        UIView.transition(with: cell.cardView, duration: 0.5, options: .transitionFlipFromTop, animations: nil, completion: nil)
                    }
                    .disposed(by: cell.disposeBag)
                
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

                        let isUser = UserClassification.isUser(compareID: profileID)
                        
                        if isUser { //userID가 자신일 경우
                            let vc = ProfileViewController()
                            Transition.push(nowVC: owner, toVC: vc)
                        } else {
                            let vc = OtherProfileViewController()
                            vc.userID = profileID
                            Transition.push(nowVC: owner, toVC: vc)
                        }
                    }
                    .disposed(by: cell.disposeBag)

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
                        Transition.sheet(nowVC: owner, toVC: vc)
                    }
                    .disposed(by: cell.disposeBag)
                
                cell.pageControl.rx.controlEvent(.valueChanged)
                    .map { return cell.pageControl.currentPage }
                    .subscribe(with: self) { owner, page in
                        cell.postImage.contentOffset.x = UIScreen.main.bounds.width * CGFloat(page)
                    }
                    .disposed(by: cell.disposeBag)
                
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
