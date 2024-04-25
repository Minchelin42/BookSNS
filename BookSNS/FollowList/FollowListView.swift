//
//  FollowListView.swift
//  BookSNS
//
//  Created by 민지은 on 2024/04/25.
//

import UIKit
import SnapKit

class FollowListView: BaseView {
    
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
//        tableView.backgroundColor = .systemPink
        
        tableView.rowHeight = 56
        
        tableView.register(FollowListTableViewCell.self, forCellReuseIdentifier: FollowListTableViewCell.identifier)
    }
 
}
