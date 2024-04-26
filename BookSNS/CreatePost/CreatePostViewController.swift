//
//  CreatePostViewController.swift
//  BookSNS
//
//  Created by 민지은 on 2024/04/13.
//

import UIKit
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
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapView(_:)))
        mainView.addGestureRecognizer(tapGesture)
    }
    
    override func bind() {
        
        self.navigationItem.rx.title.onNext("게시글 작성")
        
        let input = CreatePostViewModel.Input(contentText: mainView.textView.rx.text.orEmpty, imageData: PublishSubject<[Data?]>(), fileData: PublishSubject<[String]>(), imageRegisterButtonTapped: mainView.imageRegisterButton.rx.tap, searchBookButtonTapped: mainView.searchBookButton.rx.tap, createButtonTapped: mainView.createButton.rx.tap)
        
        let output = viewModel.transform(input: input)
        
        if type == .edit {
            print("edit 작동")
            self.navigationItem.rx.title.onNext("게시글 수정")
            let editInput = EditPostViewModel.Input(loadPost: PublishSubject<String>())
            
            let editOutput = editViewModel.transform(input: editInput)
            
            editOutput.postResult
                .subscribe(with: self) { owner, result in
                    owner.mainView.textView.text = result.content
                    owner.mainView.textView.textColor = .black
                    input.fileData.onNext(result.files)
                    owner.viewModel.selectedBook.onNext(BookModel(title: result.content1, priceStandard: Int(result.content2)!
                                                            , link: result.content3, cover: result.content4))
                }
                .disposed(by: disposeBag)
            
            input.fileData
                .bind(to: mainView.collectionView.rx.items(cellIdentifier: InputImageCollectionViewCell.identifier, cellType: InputImageCollectionViewCell.self)
                ) { row, element, cell in
                    
                    cell.deleteButton.isHidden = true
                    
                    let modifier = AnyModifier { request in
                        var r = request
                        r.setValue(UserDefaults.standard.string(forKey: "accessToken"), forHTTPHeaderField: HTTPHeader.authorization.rawValue)
                        r.setValue(APIKey.sesacKey.rawValue, forHTTPHeaderField: HTTPHeader.sesacKey.rawValue)
                        return r
                    }

                    if !element.isEmpty {
                        let url = URL(string: APIKey.baseURL.rawValue + "/" + element)!
                        
                        cell.inputImage.kf.setImage(with: url, options: [.requestModifier(modifier)])
                    }
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
                if owner.type == .create {
                    print("imageRegisterButtonTapped")
                    let vc = UIImagePickerController()
                    vc.delegate = self
                    vc.allowsEditing = true
                    owner.present(vc, animated: true)
                } else {
                    print("이미지 등록 불가")
                }
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
                if owner.type == .create {
                    let alert = UIAlertController(title: value ? "게시글 등록 완료" : "게시글 등록 실패", message: nil, preferredStyle: .alert)

                    let button = UIAlertAction(title: "확인", style: .default) { action in
                        owner.updatePost?()
                        owner.dismiss(animated: true)
                    }
                    alert.addAction(button)
                
                    owner.present(alert, animated: true)
                } else {
                    let alert = UIAlertController(title: value ? "게시글 수정 완료" : "게시글 수정 실패", message: nil, preferredStyle: .alert)

                    let button = UIAlertAction(title: "확인", style: .default) { action in
                        owner.updatePost?()
                        owner.navigationController?.popViewController(animated: true)
                    }
                    alert.addAction(button)
                    
                    owner.present(alert, animated: true)
                }
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
    
    
    @objc func tapView(_ sender: UITapGestureRecognizer) {
        print(#function)
        view.endEditing(true)
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
