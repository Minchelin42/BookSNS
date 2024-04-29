//
//  StoryViewModel.swift
//  BookSNS
//
//  Created by 민지은 on 2024/04/28.
//

import Foundation
import RxSwift
import RxCocoa

class StoryViewModel: ViewModelType {
    var disposeBag = DisposeBag()
 
    struct Input {
        let searchListType: PublishSubject<String>
    }
    
    struct Output {
        let searchResult: PublishSubject<[BookModel]>
    }
    
    func transform(input: Input) -> Output {
        let searchResult = PublishSubject<[BookModel]>()
        
        input.searchListType
            .flatMap { type in
                return  SearchBookNetwork.searchBook(router: SearchBookRouter.getBookRank(queryType: type))
            }
            .subscribe(with: self) { owner, bookList in
                searchResult.onNext(bookList)
            }
            .disposed(by: disposeBag)

        return Output(searchResult: searchResult)
    }
    
}
