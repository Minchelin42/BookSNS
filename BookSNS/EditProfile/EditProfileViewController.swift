//
//  EditProfileViewController.swift
//  BookSNS
//
//  Created by 민지은 on 2024/04/22.
//

import UIKit
import RxSwift
import RxCocoa
import Kingfisher

class EditProfileViewController: RxBaseViewController {
    
    let mainView = EditProfileView()
    let viewModel = EditProfileViewModel()
    
    var edit: ((Bool) -> Void)?

    override func loadView() {
        self.view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        
        navigationItem.rx.title.onNext("프로필 수정")
    }
    
    override func bind() {
        
        let input = EditProfileViewModel.Input(nickNameText: mainView.nickNameTextField.rx.text.orEmpty, editImageButtonTapped: mainView.imageEditButton.rx.tap, editButtonTapped: PublishSubject<ProfileQuery>())
        
        let output = viewModel.transform(input: input)
        
        viewModel.nickName
            .subscribe(with: self) { owner, nickName in
                owner.mainView.nickNameTextField.text = nickName
            }
            .disposed(by: disposeBag)
        
        viewModel.id
            .subscribe(with: self) { owner, id in
                owner.mainView.userIdLabel.text = id
            }
            .disposed(by: disposeBag)
        
        viewModel.profileImage
            .subscribe(with: self) { owner, profileImage in  
                let url = URL(string: APIKey.baseURL.rawValue + "/" + profileImage)!
                
                owner.loadImage(loadURL: url, defaultImg: "defaultProfile") { resultImage in
                    owner.mainView.profileImageView.image = resultImage
                }
                
            }
            .disposed(by: disposeBag)
        
        output.editProfileSuccess
            .subscribe(with: self) { owner, value in
                let alertTitle = value ? "프로필 수정 완료" : "프로필 수정 실패"
                owner.oneButtonAlert(alertTitle) {
                    owner.edit?(value)
                    owner.navigationController?.popViewController(animated: true)
                }
            }
            .disposed(by: disposeBag)
        
        mainView.imageEditButton.rx.tap
            .subscribe(with: self) { owner, _ in
                let vc = UIImagePickerController()
                vc.delegate = self
                vc.allowsEditing = true
                owner.present(vc, animated: true)
            }
            .disposed(by: disposeBag)
        
        mainView.editButton.rx.tap
            .map {
                let nick = self.mainView.nickNameTextField.text
                guard let profile = self.mainView.profileImageView.image else {
                    return ProfileQuery(nick: nick ?? "", profile: (UIImage(named: "defaultProfile")?.pngData())!)
                }
                return ProfileQuery(nick: nick ?? "", profile: profile.pngData()!)
                
            }
            .subscribe(with: self) { owner, profileQuery in
                print(profileQuery)
                input.editButtonTapped.onNext(profileQuery)
            }
            .disposed(by: disposeBag)
        
        viewModel.id.onNext(UserDefaults.standard.string(forKey: "email") ?? "")
        viewModel.profileImage.onNext(UserDefaults.standard.string(forKey: "profileImage") ?? "")
        viewModel.nickName.onNext(UserDefaults.standard.string(forKey: "nick") ?? "")
 
    }

}

extension EditProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            print("이미지 추가됨")
            self.mainView.profileImageView.image = pickedImage
            print("여기서 용량", pickedImage.pngData())
        }
        dismiss(animated: true)
    }
    
    
}
