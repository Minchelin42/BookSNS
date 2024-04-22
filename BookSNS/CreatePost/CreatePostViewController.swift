//
//  CreatePostViewController.swift
//  BookSNS
//
//  Created by 민지은 on 2024/04/13.
//

import UIKit
import RxSwift
import RxCocoa

enum PostType {
    case create
    case edit
}

class CreatePostViewController: RxBaseViewController {
    
    var type = PostType.create
    
    var id = ""
    
    let mainView = CreatePostView()
    let viewModel = CreatePostViewModel()
    let editViewModel = EditPostViewModel()
    
    override func loadView() {
        self.view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapView(_:)))
        mainView.addGestureRecognizer(tapGesture)
    }
    
    deinit {
        print("CreatePostViewController deinit")
    }
    
    override func bind() {
        
        let input = CreatePostViewModel.Input(contentText: mainView.textView.rx.text.orEmpty, imageData: PublishSubject<[Data?]>(), fileData: PublishSubject<[String]>(), imageRegisterButtonTapped: mainView.imageRegisterButton.rx.tap, searchBookButtonTapped: mainView.searchBookButton.rx.tap, createButtonTapped: mainView.createButton.rx.tap)
        
        let output = viewModel.transform(input: input)
        
        if type == .edit {
            print("edit 작동")
            let editInput = EditPostViewModel.Input(loadPost: PublishSubject<String>())
            
            let editOutput = editViewModel.transform(input: editInput)
            
            editOutput.postResult
                .subscribe(with: self) { owner, result in
                    owner.mainView.textView.text = result.content
                    owner.mainView.textView.textColor = .black
                    input.fileData.onNext(result.files)
                }
                .disposed(by: disposeBag)
            
            editInput.loadPost.onNext(self.id)
            
            viewModel.type = .edit
            viewModel.id = self.id
        }

        viewModel.inputImageData
            .subscribe(with: self) { owner, value in
                input.imageData.onNext(value)
            }
            .disposed(by: disposeBag)
        
        output.imageRegisterButtonTapped
            .drive(with: self) { owner, _ in
                print("imageRegisterButtonTapped")
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
                    owner.viewModel.selectedBook.onNext(book)
                }
                owner.present(vc, animated: true)
            }
            .disposed(by: disposeBag)
        
        output.createSuccesss
            .subscribe(with: self) { owner, value in
                
                let alert = UIAlertController(title: value ? "게시글 등록 완료" : "게시글 등록 실패", message: nil, preferredStyle: .alert)
                
                
                let button = UIAlertAction(title: "확인", style: .default)
                alert.addAction(button)
                
                owner.present(alert, animated: true)
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
            self.viewModel.imageData.append(pickedImage.pngData())
            self.viewModel.inputImageData.onNext(self.viewModel.imageData)
        }
        dismiss(animated: true)
    }
    
    
}
