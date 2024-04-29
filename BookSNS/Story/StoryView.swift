//
//  StoryView.swift
//  BookSNS
//
//  Created by 민지은 on 2024/04/28.
//

import UIKit
import SnapKit

class StoryView: BaseView {
    
    let stackView = UIStackView()
    let testImage = UIImageView()
    let leftView = UIView()
    let rightView = UIView()

    let prevTapGesture = UITapGestureRecognizer()
    let nextTapGesture = UITapGestureRecognizer()
    
    override func configureHierarchy() {
        addSubview(testImage)
        addSubview(stackView)
        addSubview(leftView)
        addSubview(rightView)
        leftView.addGestureRecognizer(prevTapGesture)
        rightView.addGestureRecognizer(nextTapGesture)
    }
    
    override func configureLayout() {
        stackView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
                .offset(12)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(4)
        }
        
        testImage.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide)
        }
        
        leftView.snp.makeConstraints { make in
            make.leading.top.bottom.equalTo(safeAreaLayoutGuide)
            make.trailing.equalTo(self.snp.centerX)
        }
        
        rightView.snp.makeConstraints { make in
            make.trailing.top.bottom.equalTo(safeAreaLayoutGuide)
            make.leading.equalTo(self.snp.centerX)
        }
    }
    
    override func configureView() {
        stackView.axis = .horizontal
        stackView.spacing = 4
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false

        leftView.backgroundColor = .clear
        rightView.backgroundColor = .clear
        
        
        testImage.contentMode = .scaleAspectFill
    }
}
