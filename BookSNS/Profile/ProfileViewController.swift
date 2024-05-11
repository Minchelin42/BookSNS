//
//  ProfileViewController.swift
//  BookSNS
//
//  Created by 민지은 on 2024/04/18.
//

import UIKit
import RxSwift
import RxCocoa
import Kingfisher

class ProfileViewController: RxBaseViewController {

    let mainView = ProfileView()
    let viewModel = ProfileViewModel.shared
    
    lazy var logout = UIAction(title: "로그아웃", image: UIImage(named: "Logout"), handler: { action in
        print("로그아웃")
        UserDefaults.standard.setValue("", forKey: "accessToken")
        UserDefaults.standard.set("", forKey: "refreshToken")
        UserDefaults.standard.set("", forKey: "profileImage")
        UserDefaults.standard.set("", forKey: "userID")
        UserDefaults.standard.set("", forKey: "email")
        UserDefaults.standard.set("", forKey: "nick")
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        
        let sceneDelegate = windowScene?.delegate as? SceneDelegate
        
        let vc = UINavigationController(rootViewController: SignInViewController())

        sceneDelegate?.window?.rootViewController = vc
        sceneDelegate?.window?.makeKeyAndVisible()
    })
                               
    lazy var withDraw = UIAction(title: "회원탈퇴", image: UIImage(named: "WithDraw"), attributes: .destructive, handler: { action in
        
        self.withDrawAlert()
    })

    lazy var menu: UIMenu = {
        return UIMenu(title: "", children: [logout, withDraw])
    }()
    
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "내 프로필"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gearshape"), style: .plain, target: self, action: nil)
        navigationItem.rightBarButtonItem!.menu = menu
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: Color.mainColor]
        self.navigationController?.navigationBar.tintColor = Color.mainColor
    }
    
    override func bind() {
        let input = ProfileViewModel.Input(loadProfile: PublishSubject<Void>(), scrapButtonClicked: mainView.scrapButton.rx.tap, postButtonClicked: mainView.postButton.rx.tap)

        let output = viewModel.transform(input: input)
        
        output.selectPostButton.subscribe(with: self) { owner, value in
            if value { //게시글 버튼을 눌렀을 때
                owner.mainView.postButton.rx.backgroundColor.onNext(Color.mainColor)
                owner.mainView.scrapButton.rx.backgroundColor.onNext(.white)
                owner.mainView.postButton.rx.image(for: .normal).onNext(UIImage(named: "Grid.fill"))
                owner.mainView.scrapButton.rx.image(for: .normal).onNext(UIImage(named: "Bookmark"))
            } else { //좋아요 버튼 눌렀을 때
                owner.mainView.scrapButton.rx.backgroundColor.onNext(Color.mainColor)
                owner.mainView.postButton.rx.backgroundColor.onNext(.white)
                owner.mainView.postButton.rx.image(for: .normal).onNext(UIImage(named: "Grid"))
                owner.mainView.scrapButton.rx.image(for: .normal).onNext(UIImage(named: "Bookmark.lightFill"))
            }
        }
        .disposed(by: disposeBag)

        output.profileInfo
            .subscribe(with: self) { owner, profile in
                owner.mainView.profileName.text = profile.nick
                owner.mainView.postNumLabel.text = "\(profile.posts.count)"
                owner.mainView.followerButton.setTitle("\(profile.followers.count)", for: .normal)
                owner.mainView.followingButton.setTitle("\(profile.following.count)", for: .normal)
                
                output.selectPostButton.onNext(true)

                let url = URL(string: APIKey.baseURL.rawValue + "/" + profile.profileImage)!
                
                owner.loadImage(loadURL: url, defaultImg: "defaultProfile") { resultImage in
                    owner.mainView.profileImage.image = resultImage
                }
               
            }
            .disposed(by: disposeBag)
        
        output.postResult
            .bind(to: mainView.collectionView.rx.items(cellIdentifier: PostCollectionViewCell.identifier, cellType: PostCollectionViewCell.self)
            ) { row, element, cell in
                
                NetworkManager.APIcall(type: PostModel.self, router: PostRouter.getThisPost(id: element))
                    .catch { error in
                        return Single<PostModel>.never()
                    }
                    .subscribe(with: self) { owner, postModel in
                        if postModel.product_id == "snapBook_market" {
                            cell.marketMark.isHidden = false
                        }
                        
                        let url = URL(string: APIKey.baseURL.rawValue + "/" + postModel.files[0])!
                        
                        owner.loadImage(loadURL: url, defaultImg: "defaultProfile") { resultImage in
                            cell.postImageView.image = resultImage
                        }
                    }
                .disposed(by: self.disposeBag)

            }
            .disposed(by: disposeBag)
        
        self.mainView.followingButton.rx.tap
            .subscribe(with: self) { owner, _ in
                let vc = FollowViewController()
                vc.userID = UserDefaults.standard.string(forKey: "userID") ?? ""
                vc.selectType = .following
                owner.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)
        
        self.mainView.followerButton.rx.tap
            .subscribe(with: self) { owner, _ in
                let vc = FollowViewController()
                vc.userID = UserDefaults.standard.string(forKey: "userID") ?? ""
                vc.selectType = .follower
                owner.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)
        
        
        self.mainView.profileEditButton.rx.tap
            .subscribe(with: self) { owner, _ in
                let vc = EditProfileViewController()
                vc.edit = { isEdit in
                    if isEdit {
                        input.loadProfile.onNext(())
                    }
                }
                owner.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)
        
        self.mainView.shoppingListButton.rx.tap
            .subscribe(with: self) { owner, _ in
                print("shoppingListButton 클릭")
                let vc = ShoppingListViewController()
                owner.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)
        
        self.mainView.collectionView.rx.modelSelected(String.self)
            .subscribe(with: self) { owner, postID in
                NetworkManager.APIcall(type: PostModel.self, router: PostRouter.getThisPost(id: postID))
                    .catch { error in
                        return Single<PostModel>.never()
                    }
                    .subscribe(with: self) { owner, postModel in
                   
                    if postModel.product_id == "snapBook" {
                        let vc = SelectPostViewController()
                        vc.postID = postID
                        owner.navigationController?.pushViewController(vc, animated: true)
                    } else {
                        let vc = MarketSelectPostViewController()
                        vc.postID = postID
                        owner.navigationController?.pushViewController(vc, animated: true)
                    }
                }
                .disposed(by: owner.disposeBag)
            }
            .disposed(by: disposeBag)

        input.loadProfile.onNext(())
    }
    
}

extension ProfileViewController {
    
    func withDrawAlert() {
        let alert = UIAlertController(title: "정말 탈퇴하시겠습니까?", message: "회원님의 모든 정보가 삭제되며,\n복구하실 수 없습니다", preferredStyle: .alert)
        
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        let withDraw = UIAlertAction(title: "탈퇴", style: .destructive) { action in
            print("탈퇴버튼 클릭")
            
            WithDrawViewModel.shared.withDrawAlertButtonTapped.onNext(())
            WithDrawViewModel.shared.withDrawAccess
                .subscribe(with: self) { owner, _ in
                    UserDefaults.standard.setValue("", forKey: "accessToken")
                    UserDefaults.standard.set("", forKey: "refreshToken")
                    UserDefaults.standard.set("", forKey: "profileImage")
                    UserDefaults.standard.set("", forKey: "userID")
                    UserDefaults.standard.set("", forKey: "email")
                    UserDefaults.standard.set("", forKey: "nick")
                    
                    let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
                    
                    let sceneDelegate = windowScene?.delegate as? SceneDelegate
                    
                    let vc = UINavigationController(rootViewController: SignInViewController())

                    sceneDelegate?.window?.rootViewController = vc
                    sceneDelegate?.window?.makeKeyAndVisible()
                }
                .disposed(by: self.disposeBag)
        }
        
        alert.addAction(cancel)
        alert.addAction(withDraw)

        self.present(alert, animated: true)
    }
    
}
