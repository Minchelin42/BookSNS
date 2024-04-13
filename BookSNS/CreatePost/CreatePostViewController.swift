//
//  CreatePostViewController.swift
//  BookSNS
//
//  Created by 민지은 on 2024/04/13.
//

import UIKit
import RxSwift
import RxCocoa

class CreatePostViewController: RxBaseViewController {
    
    let mainView = CreatePostView()
    let viewModel = CreatePostViewModel()
    
    override func loadView() {
        self.view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapView(_:)))
        mainView.addGestureRecognizer(tapGesture)
    }
    
    override func bind() {
        let input = CreatePostViewModel.Input(contentText: mainView.textView.rx.text.orEmpty, createButtonTapped: mainView.createButton.rx.tap)
        
        let output = viewModel.transform(input: input)
        
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
