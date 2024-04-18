//
//  GetPostView.swift
//  BookSNS
//
//  Created by 민지은 on 2024/04/16.
//

import UIKit
import SnapKit

class HomeView: BaseView {
    
    let tableView = UITableView()
    
    override func configureHierarchy() {
        addSubview(tableView)
    }
    
    override func configureLayout() {
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide)
        }
    }
    
    override func configureView() {
        tableView.backgroundColor = .darkGray
    }
  
}
