//
//  WithDrawViewModel.swift
//  BookSNS
//
//  Created by 민지은 on 2024/04/12.
//

import Foundation
import RxSwift
import RxCocoa

class WithDrawViewModel {
    
    var disposeBag = DisposeBag()
    
    static let shared = WithDrawViewModel()
    
    let withDrawAlertButtonTapped = PublishSubject<Void>()
    let withDrawAccess = PublishSubject<Void>()
    
    init() {
        withDrawAlertButtonTapped
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .flatMap { _ in
                return NetworkManager.APIcall(type: SignUpModel.self, router: Router.withdraw)
                    .catch { error in
                        return Single<SignUpModel>.never()
                    }
            }
            .subscribe(onNext: { [weak self] withDrawModel in
                print(withDrawModel)
                self?.withDrawAccess.onNext(())
            }, onError: { error in
                print("오류 발생: \(error)")
            })
            .disposed(by: disposeBag)
    }

}
