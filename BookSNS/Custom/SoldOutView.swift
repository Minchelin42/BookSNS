//
//  SoldOutView.swift
//  BookSNS
//
//  Created by 민지은 on 2024/05/03.
//

import UIKit
import SnapKit

class SoldOutView: BaseView {
    
    let soldOutLabel = {
       let label = UILabel()
        label.text = "판매완료"
        label.font = .systemFont(ofSize: 65, weight: .semibold)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()

    override func configureHierarchy() {
        addSubview(soldOutLabel)
    }
    
    override func configureLayout() {
        soldOutLabel.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide)
        }
    }
    
    override func configureView() {
        backgroundColor = Color.mainColor?.withAlphaComponent(0.3)
    }
}
