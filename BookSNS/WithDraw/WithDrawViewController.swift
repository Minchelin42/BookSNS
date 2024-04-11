//
//  WithDrawViewController.swift
//  BookSNS
//
//  Created by 민지은 on 2024/04/12.
//

import UIKit

class WithDrawViewController: RxBaseViewController {
    
    let mainView = WithDrawView()
    let viewModel = WithDrawViewModel()
    
    override func loadView() {
        self.view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func bind() {
        let input = WithDrawViewModel.Input(withDrawButtonClicked: mainView.withDrawButton.rx.tap.asObservable())
            
        let output = viewModel.transform(input: input)
        
        var email = ""
        var nick = ""
        
        output.userEmail.subscribe(with: self) { owner, value in
            email = value
        }
        .disposed(by: disposeBag)
        
        output.userNick.subscribe(with: self) { owner, value in
            nick = value
        }
        .disposed(by: disposeBag)

        output.withDrawButtonTapped
            .drive(with: self) { owner, _ in
                let alert = UIAlertController(title: "\(email)님 탈퇴 완료", message: "\(nick)에 관한 내용은 모두 소멸됩니다", preferredStyle: .alert)
                let button = UIAlertAction(title: "확인", style: .default)
                alert.addAction(button)
                owner.present(alert, animated: true)
            }
            .disposed(by: disposeBag)
    }

}
