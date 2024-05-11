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
    
    let haveMoreImage = PublishSubject<Bool>()
    let viewTapped = PublishSubject<Bool>()
 
    struct Input {
        let searchListType: PublishSubject<String>
    }
    
    struct Output {
        let searchResult: PublishSubject<[BookModel]>
        let searchListType: PublishSubject<String>
    }
    
    func transform(input: Input) -> Output {
        let searchResult = PublishSubject<[BookModel]>()
        let searchListType = PublishSubject<String>()
        
        input.searchListType
            .flatMap { type in
                return  SearchBookNetwork.searchBook(router: SearchBookRouter.getBookRank(queryType: type))
            }
            .subscribe(with: self) { owner, bookList in
                searchResult.onNext(bookList)
            }
            .disposed(by: disposeBag)
        
        input.searchListType
            .subscribe(with: self) { owner, type in
                
            }
            .disposed(by: disposeBag)


        return Output(searchResult: searchResult, searchListType: searchListType)
    }
    
    
    
}
