//
//  MarketPostViewController.swift
//  BookSNS
//
//  Created by 민지은 on 2024/05/02.
//

import UIKit
import RxSwift
import RxCocoa

class MarketPostViewController: RxBaseViewController {
    
    let mainView = MarketPostView()
    let viewModel = MarketPostViewModel()
    
    var updatePost: (() -> ())?
    
    var imageArr: [UIImage] = []
    let imageData = PublishSubject<[UIImage]>()
    let fileData = PublishSubject<String>()
    
    override func loadView() {
        self.view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    override func bind() {
        let input = MarketPostViewModel.Input(contentText: mainView.textView.rx.text.orEmpty, priceText: mainView.priceTextField.rx.text.orEmpty, imageData: PublishSubject<[Data?]>(), fileData: PublishSubject<[String]>(), imageRegisterButtonTapped: mainView.imageRegisterButton.rx.tap, searchBookButtonTapped: mainView.searchBookButton.rx.tap, createButtonTapped: mainView.createButton.rx.tap)
        
        let output = viewModel.transform(input: input)
        
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
                owner.present(vc, animated: true)
                
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
                owner.present(vc, animated: true)
            }
            .disposed(by: disposeBag)
        
        output.createSuccesss
            .subscribe(with: self) { owner, value in
                let alert = UIAlertController(title: value ? "게시글 등록 완료" : "게시글 등록 실패", message: nil, preferredStyle: .alert)
                
                let button = UIAlertAction(title: "확인", style: .default) { action in
                    owner.updatePost?()
                    owner.dismiss(animated: true)
                }
                alert.addAction(button)
                
                owner.present(alert, animated: true)
            }
            .disposed(by: disposeBag)
        
        viewModel.selectedBook
            .subscribe(with: self) { owner, book in
                print(book)
                owner.mainView.cardView.unknownView.isHidden = true
                owner.mainView.cardView.title.text = book.title
                owner.mainView.cardView.price.text = "\(book.priceStandard)원"
                owner.mainView.cardView.bookImage.kf.setImage(with: URL(string: book.cover)!)
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
