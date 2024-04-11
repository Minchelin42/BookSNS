//
//  BaseViewController.swift
//  BookSNS
//
//  Created by 민지은 on 2024/04/11.
//

import UIKit
import RxSwift
import RxCocoa

class RxBaseViewController: UIViewController {
    
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        bind()
    }
    
    func bind() { }

}
