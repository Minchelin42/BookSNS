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
    
    struct Input {
        let withDrawButtonClicked: Observable<Void>
    }
    
    struct Output {
        let withDrawButtonTapped: Driver<Void>
        let userEmail: PublishSubject<String>
        let userNick: PublishSubject<String>
    }
    
    func transform(input: Input) -> Output {
    
        let withDrawButtonClicked = PublishRelay<Void>()
        let userEmail = PublishSubject<String>()
        let userNick = PublishSubject<String>()

        input.withDrawButtonClicked
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .flatMap { _ in
                return NetworkManager.withDraw()
            }
            .subscribe(with: self) { owner, withDrawModel in
                userEmail.onNext(withDrawModel.email)
                userNick.onNext(withDrawModel.nick)
                withDrawButtonClicked.accept(())
            } onError: { owner, error in
                print("오류 발생")
            }
            .disposed(by: disposeBag)

        return Output(withDrawButtonTapped: withDrawButtonClicked.asDriver(onErrorJustReturn: ()), userEmail: userEmail, userNick: userNick)
    }
}
