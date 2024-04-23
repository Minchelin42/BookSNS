//
//  CommentView.swift
//  BookSNS
//
//  Created by 민지은 on 2024/04/18.
//

import UIKit
import SnapKit

class CommentView: BaseView {
    let tableView = UITableView()
    let textField = CommentTextField()
    let registerButton = CommentButton()
    
    override func configureHierarchy() {
        addSubview(tableView)
        addSubview(textField)
        addSubview(registerButton)
        
    }
    
    override func configureLayout() {
        tableView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(30)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide)
            make.bottom.equalTo(textField.snp.top).offset(-12)
        }
        
        textField.snp.makeConstraints { make in
            make.top.equalTo(tableView.snp.bottom).offset(12)
            make.height.equalTo(40)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(12)
            make.bottom.equalTo(safeAreaLayoutGuide).inset(12)
        }
        
        registerButton.snp.makeConstraints { make in
            make.size.equalTo(28)
            make.trailing.equalTo(textField.snp.trailing).inset(10)
            make.centerY.equalTo(textField)
        }
    }
    
    override func configureView() {
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
    }
    
}
