//
//  MarketPostViewController.swift
//  BookSNS
//
//  Created by 민지은 on 2024/05/02.
//

import UIKit
import RxSwift
import RxCocoa
import Kingfisher

class MarketPostViewController: RxBaseViewController {
    
    let mainView = MarketPostView()
    let viewModel = MarketPostViewModel()
    
    var updatePost: (() -> ())?
    
    var id = ""
    
    var imageArr: [UIImage] = []
    let imageData = PublishSubject<[UIImage]>()
    let fileData = PublishSubject<String>()
    
    override func loadView() {
        self.view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rx.title.onNext("판매글 작성")
        
        viewModel.postID.onNext(id)
    }
    
    override func bind() {
        let input = MarketPostViewModel.Input(contentText: mainView.textView.rx.text.orEmpty, priceText: mainView.priceTextField.rx.text.orEmpty, imageData: PublishSubject<[Data?]>(), fileData: PublishSubject<[String]>(), imageRegisterButtonTapped: mainView.imageRegisterButton.rx.tap, searchBookButtonTapped: mainView.searchBookButton.rx.tap, createButtonTapped: mainView.createButton.rx.tap)
        
        let output = viewModel.transform(input: input)
        
        output.requiredMessage
            .subscribe(with: self) { owner, message in
                owner.makeToast(message)
            }
            .disposed(by: disposeBag)
        
        viewModel.postResult
            .subscribe(with: self) { owner, result in
                owner.mainView.updateView(result)
                owner.navigationItem.rx.title.onNext("판매글 수정")

                input.fileData.onNext(result.files)
                owner.viewModel.selectedBook.onNext(BookModel(title: result.content1, priceStandard: Int(result.content2)!, link: result.content3, cover: result.content5))
            }
            .disposed(by: disposeBag)
        
        if !self.id.isEmpty {
            input.fileData
                .bind(to: self.mainView.collectionView.rx.items(cellIdentifier: InputImageCollectionViewCell.identifier, cellType: InputImageCollectionViewCell.self)
                ) { row, element, cell in
                    
                    cell.deleteButton.isHidden = true

                    MakeUI.loadImage(loadURL: MakeUI.makeURL(element), defaultImg: "defaultProfile") { resultImage in
                        print("completionHandler")
                        cell.inputImage.image = resultImage
                    }
                }
                .disposed(by: disposeBag)
        } else {
            self.imageData
                .bind(to: mainView.collectionView.rx.items(cellIdentifier: InputImageCollectionViewCell.identifier, cellType: InputImageCollectionViewCell.self)
                ) { row, element, cell in
                    cell.inputImage.image = element
                    cell.deleteButton.tag = row
                    cell.deleteButtonTap = {
                        self.imageArr.remove(at: cell.deleteButton.tag)
                        self.imageData.onNext(self.imageArr)
                    }
                }
                .disposed(by: disposeBag)
        }
        
        
        viewModel.inputImageData
            .subscribe(with: self) { owner, value in
                input.imageData.onNext(value)
            }
            .disposed(by: disposeBag)
        
        output.imageRegisterButtonTapped
            .drive(with: self) { owner, _ in
                let vc = UIImagePickerController()
                vc.delegate = self
                vc.allowsEditing = true
                Transition.present(nowVC: owner, toVC: vc)
                
            }
            .disposed(by: disposeBag)
        
        output.searchBookButtonTapped
            .drive(with: self) { owner, _ in
                print("searchBookButtonTapped")
                let vc = SearchBookViewController()
                vc.selectBook = { book in
                    if !book.title.isEmpty {
                        owner.viewModel.selectedBook.onNext(book)
                    }
                }
                Transition.present(nowVC: owner, toVC: vc)
            }
            .disposed(by: disposeBag)
        
        output.createSuccesss
            .subscribe(with: self) { owner, value in
                
                let alertTitle = value ? (owner.id.isEmpty ? "판매글 등록 완료" : "판매글 수정 완료") : (owner.id.isEmpty ? "판매글 등록 실패" : "판매글 수정 실패")
                
                self.oneButtonAlert(alertTitle) {
                    owner.updatePost?()
                    
                    if owner.id.isEmpty {
                        MarketHomeViewModel.shared.updatePost.onNext(())
                        ProfileViewModel.shared.updateProfile.onNext(())
                        Transition.dismiss(owner)
                    } else {
                        Transition.pop(owner)
                    }
                }
            }
            .disposed(by: disposeBag)
        
        viewModel.selectedBook
            .subscribe(with: self) { owner, book in
                owner.mainView.updateCardView(book)
            }
            .disposed(by: disposeBag)
        
    }
}

extension MarketPostViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            print("이미지 추가됨")
            self.imageArr.append(pickedImage)
            self.imageData.onNext(imageArr)
            self.viewModel.imageData.append(pickedImage.pngData())
            self.viewModel.inputImageData.onNext(self.viewModel.imageData)
        }
        dismiss(animated: true)
    }
    
    
}
