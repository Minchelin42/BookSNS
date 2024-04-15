//
//  SearchBookViewController.swift
//  BookSNS
//
//  Created by 민지은 on 2024/04/14.
//

import UIKit

class SearchBookViewController: RxBaseViewController {
    
    let mainView = SearchBookView()
    let viewModel = SearchBookViewModel()
    
    var selectBook: ((BookModel) -> Void)?
    
    override func loadView() {
        self.view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.tableView.register(SearchBookTableViewCell.self, forCellReuseIdentifier: SearchBookTableViewCell.identifier)
        mainView.tableView.rowHeight = 94
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        selectBook?(viewModel.selectedBook)
    }
    
    deinit {
        print("SearchBookController deinit")
    }
    
    override func bind() {
        let input = SearchBookViewModel.Input(searchText: mainView.searchBar.rx.text.orEmpty, searchButtonTapped: mainView.searchBar.rx.searchButtonClicked)
        
        let output = viewModel.transform(input: input)
        
        output.searchResult
            .bind(to: mainView.tableView.rx.items(
                cellIdentifier: SearchBookTableViewCell.identifier,
                cellType: SearchBookTableViewCell.self)
            ) {(row, element, cell) in
                cell.title.text = element.title
                cell.price.text = "\(element.priceStandard)"
            }
            .disposed(by: disposeBag)
        
        mainView.tableView.rx.modelSelected(BookModel.self)
            .subscribe(with: self) { owner, book in
                owner.viewModel.selectedBook = book
                owner.dismiss(animated: true)
            }
            .disposed(by: disposeBag)

    }

}


