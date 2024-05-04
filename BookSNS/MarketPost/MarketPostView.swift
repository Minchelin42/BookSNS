//
//  MarketPostView.swift
//  BookSNS
//
//  Created by 민지은 on 2024/05/02.
//

import UIKit
import SnapKit

class MarketPostView: BaseView {
    
    //중고글 게시, 수정 모두 여기서 할 것
    
    let imageRegisterButton = InputImageButton()
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: configureCollectionViewLayout())
    
    lazy var textView = {
        let textView = UITextView()
        textView.text = placeholderText
        textView.textColor = Color.lightPoint
        textView.clipsToBounds = true
        textView.layer.cornerRadius = 11
        textView.layer.borderColor = Color.lightPoint?.cgColor
        textView.layer.borderWidth = 1
        return textView
    }()
    
    let searchBookButton = ProfileEditButton()
    let cardView = BookCardView()
    
    let priceLabel = {
        let label = UILabel()
        label.text = "판매 금액"
        label.font = .systemFont(ofSize: 15, weight: .semibold)
        return label
    }()
    
    let priceTextField = SignTextField()
    
    let createButton = ProfileEditButton()
    
    let guideLabel = {
       let label = UILabel()
        label.text = "판매종료 이후 해당 게시글의 수정 및 삭제는 불가능합니다"
        label.textColor = .red
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textAlignment = .center
        return label
    }()

    let placeholderText = "구매에 도움이 될 한마디를 작성해주세요"
    
    override func configureHierarchy() {
        addSubview(imageRegisterButton)
        addSubview(collectionView)
        addSubview(textView)
        addSubview(searchBookButton)
        addSubview(cardView)
        addSubview(priceLabel)
        addSubview(priceTextField)
        addSubview(createButton)
        addSubview(guideLabel)
    }
    
    override func configureLayout() {
        imageRegisterButton.snp.makeConstraints { make in
            make.top.leading.equalTo(safeAreaLayoutGuide).inset(20)
            make.size.equalTo(80)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.trailing.equalTo(safeAreaLayoutGuide).inset(20)
            make.leading.equalTo(imageRegisterButton.snp.trailing).offset(4)
            make.height.equalTo(80)
        }
        
        textView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(20)
            make.height.equalTo(50)
            make.top.equalTo(imageRegisterButton.snp.bottom).offset(12)
        }
        
        searchBookButton.snp.makeConstraints { make in
            make.top.equalTo(textView.snp.bottom).offset(12)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(20)
            make.height.equalTo(50)
        }
        
        cardView.snp.makeConstraints { make in
            make.top.equalTo(searchBookButton.snp.bottom).offset(12)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(16)
            make.height.equalTo(100)
        }
        
        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(cardView.snp.bottom).offset(12)
            make.leading.equalTo(safeAreaLayoutGuide).inset(20)
            make.width.equalTo(60)
            make.height.equalTo(45)
        }
        
        priceTextField.snp.makeConstraints { make in
            make.top.equalTo(priceLabel.snp.top)
            make.trailing.equalTo(safeAreaLayoutGuide).inset(16)
            make.leading.equalTo(priceLabel.snp.trailing).offset(8)
            make.height.equalTo(45)
        }
        
        createButton.snp.makeConstraints { make in
            make.top.equalTo(priceLabel.snp.bottom).offset(12)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(16)
            make.height.equalTo(50)
        }
        
        guideLabel.snp.makeConstraints { make in
            make.top.equalTo(createButton.snp.bottom).offset(8)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(16)
            make.height.equalTo(22)
        }
        
    }
    
    override func configureView() {

        searchBookButton.setTitle("판매 도서 태그", for: .normal)
        textView.delegate = self
        cardView.unknownView.isHidden = false
        cardView.clipsToBounds = true
        cardView.layer.cornerRadius = 16
        cardView.layer.borderWidth = 1
        cardView.layer.borderColor = Color.lightPoint?.cgColor
        
        priceTextField.textAlignment = .right
        priceTextField.keyboardType = .numberPad
        
        createButton.setTitle("판매글 등록", for: .normal)
        
        collectionView.register(InputImageCollectionViewCell.self, forCellWithReuseIdentifier: InputImageCollectionViewCell.identifier)
    }
    
    private func configureCollectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 80, height: 80)
        layout.minimumLineSpacing = 4
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.scrollDirection = .horizontal

        return layout
        
    }
    
}

extension MarketPostView: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == placeholderText {
            textView.text = nil
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = placeholderText
            textView.textColor = .lightGray
        }
    }
    
    
}

