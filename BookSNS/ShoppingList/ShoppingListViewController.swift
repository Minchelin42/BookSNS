//
//  ShoppingListViewController.swift
//  BookSNS
//
//  Created by 민지은 on 2024/05/03.
//

import UIKit
import RxSwift
import RxCocoa

class ShoppingListViewController: RxBaseViewController {
    
    let mainView = ShoppingListView()
    let viewModel = ShoppingListViewModel()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.rx.title.onNext("구매 내역")
    }
    
    override func bind() {
        let input = ShoppingListViewModel.Input(loadShoppingList: PublishSubject<Void>())
        
        let output = viewModel.transform(input: input)
        
        output.shoppingListResult
            .bind(to: mainView.tableView.rx.items(
                cellIdentifier: ShoppingListTableViewCell.identifier,
                cellType: ShoppingListTableViewCell.self)
            ) {(row, element, cell) in
                
                cell.titleLabel.rx.text.onNext(element.productName)
                cell.priceLabel.rx.text.onNext("\(element.price)원")
                cell.dateLabel.rx.text.onNext(convertUTCtoKST(utcString: element.paidAt))

            }
            .disposed(by: disposeBag)
        
        
        mainView.tableView.rx.modelSelected(PayValidationModel.self)
            .subscribe(with: self) { owner, result in
                let vc = MarketSelectPostViewController()
                vc.postID = result.post_id
                owner.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)
        
        input.loadShoppingList.onNext(())
    
    }

}


func convertUTCtoKST(utcString: String) -> String? {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
    dateFormatter.timeZone = TimeZone(identifier: "UTC")
    
    guard let utcDate = dateFormatter.date(from: utcString) else {
        return nil
    }
    
    dateFormatter.timeZone = TimeZone(identifier: "Asia/Seoul")
    dateFormatter.dateFormat = "yy/MM/dd"
    
    return dateFormatter.string(from: utcDate)
}
