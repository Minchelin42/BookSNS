//
//  SearchBookViewModel.swift
//  BookSNS
//
//  Created by 민지은 on 2024/04/14.
//

import Foundation
import RxSwift
import RxCocoa

class SearchBookViewModel: ViewModelType {
   
    var disposeBag = DisposeBag()
    
    var selectedBook = BookModel(title: "", priceStandard: 0, link: "", cover: "")
    
    struct Input {
        let searchText: ControlProperty<String>
        let searchButtonTapped: ControlEvent<Void>
    }
    
    struct Output {
        let searchResult: PublishSubject<[BookModel]>
    }
    
    func transform(input: Input) -> Output {
        
        let searchResult = PublishSubject<[BookModel]>()
        
        input.searchButtonTapped
            .withLatestFrom(input.searchText)
            .flatMap { title in
                return SearchBookNetwork.searchBook(router: SearchBookRouter.searchBook(title: title))
            }
            .subscribe(with: self) { owner, bookList in
                print(bookList)
                searchResult.onNext(bookList)
            }
            .disposed(by: disposeBag)
        
        return Output(searchResult: searchResult)
    }
    
}
