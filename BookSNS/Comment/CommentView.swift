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
    let textField = UITextField()
    let registerButton = UIButton()
    
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
            make.leading.equalTo(safeAreaLayoutGuide).inset(12)
            make.trailing.equalTo(registerButton.snp.trailing).inset(12)
            make.bottom.equalTo(safeAreaLayoutGuide).inset(12)
        }
        
        registerButton.snp.makeConstraints { make in
            make.size.equalTo(40)
            make.trailing.equalTo(safeAreaLayoutGuide).inset(12)
            make.bottom.equalTo(safeAreaLayoutGuide).inset(12)
        }
    }
    
    override func configureView() {
        tableView.backgroundColor = .darkGray
        
        textField.backgroundColor = .blue
        registerButton.backgroundColor = .yellow
    }
    
}
