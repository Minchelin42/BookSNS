//
//  ShoppingListViewModel.swift
//  BookSNS
//
//  Created by 민지은 on 2024/05/03.
//

import Foundation
import RxSwift
import RxCocoa

class ShoppingListViewModel: ViewModelType {
    
    var disposeBag = DisposeBag()
    
    struct Input {
        let loadShoppingList: PublishSubject<Void>
    }
    
    struct Output {
        let shoppingListResult: PublishSubject<[PayValidationModel]>
    }
    
    func transform(input: Input) -> Output {
        
        let shoppingList = PublishSubject<[PayValidationModel]>()
        
        input.loadShoppingList
            .flatMap{
                return NetworkManager.APIcall(type: PayList.self, router: MarketRouter.getShoppingList)
            }
            .subscribe(with: self) { owner, result in
                shoppingList.onNext(result.data)
            }
            .disposed(by: disposeBag)
        
        
        return Output(shoppingListResult: shoppingList)
    }
    
    
}
