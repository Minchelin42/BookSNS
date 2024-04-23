//
//  PostCreateView.swift
//  BookSNS
//
//  Created by 민지은 on 2024/04/23.
//

import UIKit
import SnapKit

class PostCreateView: BaseView {
    
    let imageRegisterButton = InputImageButton()
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: configureCollectionViewLayout())
    
    lazy var textView = {
        let textView = UITextView()
        textView.text = placeholderText
        textView.textColor = Color.lightPoint
        textView.clipsToBounds = true
        textView.layer.cornerRadius = 16
        textView.layer.borderColor = Color.lightPoint?.cgColor
        textView.layer.borderWidth = 1
        return textView
    }()
    
    let searchBookButton = ProfileEditButton()
    let cardView = BookCardView()
    let createButton = ProfileEditButton()

    let placeholderText = "본문 내용을 입력해주세요"
    
    override func configureHierarchy() {
        addSubview(imageRegisterButton)
        addSubview(collectionView)
        addSubview(textView)
        addSubview(searchBookButton)
        addSubview(cardView)
        addSubview(createButton)
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
            make.height.equalTo(200)
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
        
        createButton.snp.makeConstraints { make in
            make.top.equalTo(cardView.snp.bottom).offset(12)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(16)
            make.height.equalTo(50)
        }
        
    }
    
    override func configureView() {

        searchBookButton.setTitle("추천 도서 태그", for: .normal)
        textView.delegate = self
        cardView.unknownView.isHidden = false
        cardView.clipsToBounds = true
        cardView.layer.cornerRadius = 16
        cardView.layer.borderWidth = 1
        cardView.layer.borderColor = Color.lightPoint?.cgColor
        
        createButton.setTitle("게시글 등록", for: .normal)
        
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

extension PostCreateView: UITextViewDelegate {
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

