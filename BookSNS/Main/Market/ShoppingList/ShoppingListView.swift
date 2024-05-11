//
//  ShoppingListView.swift
//  BookSNS
//
//  Created by 민지은 on 2024/05/03.
//

import UIKit
import SnapKit

import UIKit
import SnapKit

class ShoppingListView: BaseView {
    
    let tableView = UITableView()
    
    override func configureHierarchy() {
        addSubview(tableView)
    }
    
    override func configureLayout() {
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(self)
        }
    }
    
    override func configureView() {
        tableView.rowHeight = 80
        tableView.separatorStyle = .none
        tableView.register(ShoppingListTableViewCell.self, forCellReuseIdentifier: ShoppingListTableViewCell.identifier)
    }
 
}

