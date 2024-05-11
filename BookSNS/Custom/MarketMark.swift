//
//  MarketMark.swift
//  BookSNS
//
//  Created by 민지은 on 2024/05/03.
//

import UIKit
import SnapKit

final class MarketMark: BaseView {

    private let view = {
       let view = UIView()
        view.backgroundColor = Color.mainColor
        view.clipsToBounds = true
        view.layer.cornerRadius = 7
        return view
    }()
    
    private let image = {
        let view = UIImageView()
        view.image = UIImage(systemName: "cart.fill")
        view.tintColor = .white
        return view
    }()
    
    override func configureHierarchy() {
        addSubview(view)
        addSubview(image)
    }
    
    override func configureLayout() {
        view.snp.makeConstraints { make in
            make.edges.equalTo(self)
        }
        
        image.snp.makeConstraints { make in
            make.size.equalTo(15)
            make.center.equalTo(self)
        }
    }
    
    override func configureView() {
        backgroundColor = .clear
    }

}
