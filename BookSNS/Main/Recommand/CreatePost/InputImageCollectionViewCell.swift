//
//  InputImageCollectionViewCell.swift
//  BookSNS
//
//  Created by 민지은 on 2024/04/23.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class InputImageCollectionViewCell: UICollectionViewCell {
    
    let disposeBag = DisposeBag()
    
    var deleteButtonTap: (() -> Void)?
    
    static let identifier = "InputImageCollectionViewCell"
    
    let inputImage = UIImageView()
    let deleteButton = UIButton()

    override init(frame: CGRect) {
        super.init(frame: frame)

        configureHierarchy()
        configureLayout()
        configureView()
        
        bind()
    }
    
    func bind() {
        deleteButton.rx.tap
               .subscribe(with: self, onNext: { owner, _ in
                   owner.deleteButtonTap?()
               })
               .disposed(by: disposeBag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureHierarchy() {
        contentView.addSubview(inputImage)
        contentView.addSubview(deleteButton)
        
    }
    
    private func configureLayout() {
        inputImage.snp.makeConstraints { make in
            make.edges.equalTo(contentView)
            make.size.equalTo(80)
        }
        
        deleteButton.snp.makeConstraints { make in
            make.trailing.top.equalTo(contentView).inset(4)
            make.size.equalTo(20)
        }
        
    }
    
    private func configureView() {
        inputImage.clipsToBounds = true
        inputImage.layer.cornerRadius = 4
        inputImage.backgroundColor = .yellow
        
        deleteButton.clipsToBounds = true
        deleteButton.layer.cornerRadius = 10
        deleteButton.backgroundColor = .gray
        deleteButton.setImage(UIImage(named: "Cancel"), for: .normal)
    }

}
