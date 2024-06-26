//
//  CreatePostViewController.swift
//  BookSNS
//
//  Created by 민지은 on 2024/04/13.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import Kingfisher

enum PostType {
    case create
    case edit
}

class CreatePostViewController: RxBaseViewController {
    
    var type = PostType.create
    
    var id = ""
    
    var updatePost: (() -> ())?
    
    let mainView = PostCreateView()
    let viewModel = CreatePostViewModel()
    let editViewModel = EditPostViewModel()
    
    var imageArr: [UIImage] = []
    let imageData = PublishSubject<[UIImage]>()
    let fileData = PublishSubject<String>()

    override func loadView() {
        self.view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.rx.title.onNext("게시글 작성")
    }

    override func bind() {

        let input = CreatePostViewModel.Input(contentText: mainView.textView.rx.text.orEmpty, imageData: PublishSubject<[Data?]>(), fileData: PublishSubject<[String]>(), imageRegisterButtonTapped: mainView.imageRegisterButton.rx.tap, searchBookButtonTapped: mainView.searchBookButton.rx.tap, createButtonTapped: mainView.createButton.rx.tap)
        
        let output = viewModel.transform(input: input)
        
        if type == .edit {
            print("edit 작동")
            self.navigationItem.rx.title.onNext("게시글 수정")
            mainView.makeUIEditType()
            
            let editInput = EditPostViewModel.Input(loadPost: PublishSubject<String>())
            let editOutput = editViewModel.transform(input: editInput)
            
            editOutput.postResult
                .subscribe(with: self) { owner, result in
                    owner.mainView.loadEditData(result)
                    input.fileData.onNext(result.files)

                    owner.mainView.updateBook(BookModel(title: result.content1, priceStandard: Int(result.content2)!
                                                  , link: result.content3, cover: result.content4))
                }
                .disposed(by: disposeBag)
            
            input.fileData
                .bind(to: mainView.collectionView.rx.items(cellIdentifier: InputImageCollectionViewCell.identifier, cellType: InputImageCollectionViewCell.self)
                ) { row, element, cell in
                    MakeUI.loadImage(loadURL: MakeUI.makeURL(element), defaultImg: "defaultProfile") { resultImage in
                        cell.inputImage.image = resultImage
                    }
                    cell.deleteButton.isHidden = true
                }
                .disposed(by: disposeBag)
            
            editInput.loadPost.onNext(self.id)
            
            viewModel.type = .edit
            viewModel.id = self.id
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
        
        output.requiredMessage
            .subscribe(with: self) { owner, message in        
                owner.makeToast(message)
            }
            .disposed(by: disposeBag)
        
        output.createSuccesss
            .subscribe(with: self) { owner, value in
                if owner.type == .create {
                    let alertTitle = value ? "게시글 등록 완료" : "게시글 등록 실패"
                    
                    owner.oneButtonAlert(alertTitle) {
                        HomeViewModel.shared.updatePost.onNext(())
                        SearchViewModel.shared.updatePost.onNext(())
                        
                        owner.updatePost?()
                        Transition.dismiss(owner)
                    }
                    
                } else {
                    let alertTitle = value ? "게시글 수정 완료" : "게시글 수정 실패"
                    
                    owner.oneButtonAlert(alertTitle) {
                        HomeViewModel.shared.updatePost.onNext(())
                        SearchViewModel.shared.updatePost.onNext(())
                        owner.updatePost?()
                        Transition.pop(owner)
                    }
                }
            }
            .disposed(by: disposeBag)
        
        viewModel.selectedBook
            .subscribe(with: self) { owner, book in
                print(book)
                owner.mainView.updateBook(book)
            }
            .disposed(by: disposeBag)
        

    }

}

extension CreatePostViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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
