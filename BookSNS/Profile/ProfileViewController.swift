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
    let viewModel = ProfileViewModel()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

    }
    
    override func bind() {
        let input = ProfileViewModel.Input(loadProfile: PublishSubject<Void>(), scrapButtonClicked: mainView.scrapButton.rx.tap, postButtonClicked: mainView.postButton.rx.tap)

        let output = viewModel.transform(input: input)

        output.profileInfo
            .subscribe(with: self) { owner, profile in
                owner.mainView.profileName.text = profile.nick
            }
            .disposed(by: disposeBag)
        
        output.postResult
            .bind(to: mainView.collectionView.rx.items(cellIdentifier: PostCollectionViewCell.identifier, cellType: PostCollectionViewCell.self)
            ) { row, element, cell in
                
                NetworkManager.APIcall(type: PostModel.self, router: PostRouter.getThisPost(id: element)).subscribe(with: self) { owner, postModel in

                    let modifier = AnyModifier { request in
                        var r = request
                        r.setValue(UserDefaults.standard.string(forKey: "accessToken"), forHTTPHeaderField: HTTPHeader.authorization.rawValue)
                        r.setValue(APIKey.sesacKey.rawValue, forHTTPHeaderField: HTTPHeader.sesacKey.rawValue)
                        return r
                    }

                    if !postModel.files.isEmpty {
                        let url = URL(string: APIKey.baseURL.rawValue + "/" + postModel.files[0])!
                        
                        cell.postImageView.kf.setImage(with: url, options: [.requestModifier(modifier)])
                    }
                }
                .disposed(by: self.disposeBag)

            }
            .disposed(by: disposeBag)
        
        self.mainView.collectionView.rx.modelSelected(String.self)
            .subscribe(with: self) { owner, post in
                print("collectionView 클릭", post)
                
            }
            .disposed(by: disposeBag)
        
        input.loadProfile.onNext(())
    }
    
}
