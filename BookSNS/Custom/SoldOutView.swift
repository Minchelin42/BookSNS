//
//  SoldOutView.swift
//  BookSNS
//
//  Created by 민지은 on 2024/05/03.
//

import UIKit
import SnapKit

final class SoldOutView: BaseView {

    private let soldOutLabel = CustomLabel(size: 65, weight: .semibold, color: .white, text: "판매완료", alignment: .center)

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
    
    func setLabelStyle(size: CGFloat, weight: UIFont.Weight) {
        soldOutLabel.font = .systemFont(ofSize: size, weight: weight)
    }
}
