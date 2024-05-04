//
//  SearchBookView.swift
//  BookSNS
//
//  Created by 민지은 on 2024/04/14.
//

import UIKit
import SnapKit

class SearchBookView: BaseView {
    
    let searchBar = UISearchBar()
    let tableView = UITableView()
    
    override func configureHierarchy() {
        addSubview(searchBar)
        addSubview(tableView)
    }
    
    override func configureLayout() {
        searchBar.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(safeAreaLayoutGuide)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom)
            make.horizontalEdges.bottom.equalTo(safeAreaLayoutGuide)
        }
    }
    
    override func configureView() {
        tableView.backgroundColor = .clear
        searchBar.placeholder = "태그할 책 제목을 입력해주세요"
    }
    
    
    
}
