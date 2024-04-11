//
//  WithDrawView.swift
//  BookSNS
//
//  Created by 민지은 on 2024/04/12.
//

import UIKit
import SnapKit

class WithDrawView: BaseView {
    
    let withDrawButton = UIButton()
    
    override func configureHierarchy() {
        addSubview(withDrawButton)
    }
    
    override func configureLayout() {
        withDrawButton.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(50)
            make.bottom.equalTo(safeAreaLayoutGuide).inset(50)
            make.height.equalTo(50)
        }
    }
    
    override func configureView() {
        withDrawButton.backgroundColor = .red
        withDrawButton.setTitle("탈퇴하기", for: .normal)
    }

}
