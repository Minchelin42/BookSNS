//
//  MarketHomeViewController.swift
//  BookSNS
//
//  Created by 민지은 on 2024/05/02.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import Kingfisher

struct MarketPost: Hashable, Identifiable {
    let id = UUID()
    
    let post_id: String
    let file_id: String
    let title: String
    let price: String
    let cover: String
    let soldOut: Bool
}

class MarketHomeViewController: RxBaseViewController {
    
    let viewModel = MarketHomeViewModel.shared

    var item: [MarketPost] = []
    
    enum Section: CaseIterable {
        case main
    }
    
    private lazy var collectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: .marketPostLayout)
        view.delegate = self
        view.alwaysBounceVertical = true
        view.backgroundColor = .white
        view.register(MarketHomeCollectionViewCell.self, forCellWithReuseIdentifier: MarketHomeCollectionViewCell.identifier)
        
        return view
    }()
    
    var dataSource: UICollectionViewDiffableDataSource<Section, MarketPost>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setConstraints()
        configureDataSource()
        customTitle()
        updateSnapshot(item: [])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.updatePost.onNext(())
    }
    
    override func bind() {
        
        let input = MarketHomeViewModel.Input(getPost: PublishSubject<Void>())
        
        viewModel.transform(input: input)

        viewModel.postResult
            .bind(with: self) { owner, result in
                owner.item.removeAll()
                for index in 0..<result.count {
                    let post = result[index]
                    if !post.files.isEmpty {
                        owner.item.append(MarketPost(post_id: post.post_id, file_id: post.files[0], title: post.content1, price: post.content4, cover: post.content5, soldOut: !post.likes2.isEmpty))
                    } else {
                        owner.item.append(MarketPost(post_id: post.post_id, file_id: "", title: post.content1, price: post.content4, cover:post.content5, soldOut: !post.likes2.isEmpty))
                    }
                    
                }
                
                owner.updateSnapshot(item: owner.item)
            }
            .disposed(by: disposeBag)
        
        collectionView.rx.didEndDragging
            .debounce(.seconds(0), scheduler: MainScheduler.instance)
            .withLatestFrom(collectionView.rx.contentOffset)
            .map { [weak self] contentOffset in
                guard let collectionView = self?.collectionView else { return false }

                return collectionView.contentSize.height - contentOffset.y < UIScreen.main.bounds.height
            }
            .subscribe(with: self) { owner, isScroll in
                if isScroll {
                    if !owner.viewModel.next_cursor.isEmpty {
                        input.getPost.onNext(())
                    }
                }
            }
            .disposed(by: disposeBag)
        
        input.getPost.onNext(())
          
    }
    
    
    private func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .absolute(44))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    private func setConstraints() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func configureDataSource() {
        
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, String> { cell, indexPath, itemIdentifier in
            
            var content = UIListContentConfiguration.subtitleCell()
            content.text = itemIdentifier
            cell.contentConfiguration = content
            
            var background = UIBackgroundConfiguration.listPlainCell()
            background.backgroundColor = .lightGray
            cell.backgroundConfiguration = background
            
        }
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MarketHomeCollectionViewCell.identifier, for: indexPath)

            if let url = URL(string: itemIdentifier.cover) {
                (cell as? MarketHomeCollectionViewCell)?.photoImageView.kf.setImage(with: url)
            } else {
                (cell as? MarketHomeCollectionViewCell)?.photoImageView.image = UIImage(named: "Book")
            }
                 
            (cell as? MarketHomeCollectionViewCell)?.titleLabel.text = itemIdentifier.title
            (cell as? MarketHomeCollectionViewCell)?.priceLabel.text = "\(itemIdentifier.price.makePrice)원"
            
            if itemIdentifier.soldOut {
                (cell as? MarketHomeCollectionViewCell)?.soldOutView.isHidden = false
            }
            
            return cell
        })
    }
    
    
    private func updateSnapshot(item: [MarketPost]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, MarketPost>()
        snapshot.appendSections(Section.allCases)
        snapshot.appendItems(item)
        dataSource.apply(snapshot)
    }
    
}

extension MarketHomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let data = dataSource.itemIdentifier(for: indexPath) else {
            return
        }
        
        let vc = MarketSelectPostViewController()
        vc.postID = data.post_id
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension UICollectionViewLayout {
    static let marketPostLayout = UICollectionViewCompositionalLayout { section, environment in
        
        let margin = 1.0
        
        let firstMiniItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                       heightDimension: .fractionalHeight(0.35))
        let firstMiniItem = NSCollectionLayoutItem(layoutSize: firstMiniItemSize)
        firstMiniItem.contentInsets = NSDirectionalEdgeInsets(top: margin,
                                                              leading: margin,
                                                              bottom: margin,
                                                              trailing: margin)
        
        let secondMiniItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                        heightDimension: .fractionalHeight(0.3))
        let secondMiniItem = NSCollectionLayoutItem(layoutSize: secondMiniItemSize)
        secondMiniItem.contentInsets = NSDirectionalEdgeInsets(top: margin,
                                                               leading: margin,
                                                               bottom: margin,
                                                               trailing: margin)
        
        let thirdMiniItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                        heightDimension: .fractionalHeight(0.35))
        let thirdMiniItem = NSCollectionLayoutItem(layoutSize: thirdMiniItemSize)
        thirdMiniItem.contentInsets = NSDirectionalEdgeInsets(top: margin,
                                                               leading: margin,
                                                               bottom: margin,
                                                               trailing: margin)
        
        let miniGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: .fractionalHeight(1.0))
        let miniGroup = NSCollectionLayoutGroup.vertical(layoutSize: miniGroupSize,
                                                         subitems: [firstMiniItem, secondMiniItem, thirdMiniItem])
        
        let firstMiniItemSize1 = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                       heightDimension: .fractionalHeight(0.38))
        let firstMiniItem1 = NSCollectionLayoutItem(layoutSize: firstMiniItemSize1)
        firstMiniItem1.contentInsets = NSDirectionalEdgeInsets(top: margin,
                                                              leading: margin,
                                                              bottom: margin,
                                                              trailing: margin)
        
        let secondMiniItemSize1 = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                        heightDimension: .fractionalHeight(0.325))
        let secondMiniItem1 = NSCollectionLayoutItem(layoutSize: secondMiniItemSize1)
        secondMiniItem1.contentInsets = NSDirectionalEdgeInsets(top: margin,
                                                               leading: margin,
                                                               bottom: margin,
                                                               trailing: margin)
        
        let thirdMiniItemSize1 = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                        heightDimension: .fractionalHeight(0.295))
        let thirdMiniItem1 = NSCollectionLayoutItem(layoutSize: thirdMiniItemSize1)
        thirdMiniItem1.contentInsets = NSDirectionalEdgeInsets(top: margin,
                                                               leading: margin,
                                                               bottom: margin,
                                                               trailing: margin)

        
        let miniGroupSize1 = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: .fractionalHeight(1.0))
        let miniGroup1 = NSCollectionLayoutGroup.vertical(layoutSize: miniGroupSize1,
                                                         subitems: [firstMiniItem1, secondMiniItem1, thirdMiniItem1])
        
        
        let verticalGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5),
                                                       heightDimension: .fractionalHeight(1.0))
        
        let verticalGroup = NSCollectionLayoutGroup.horizontal(layoutSize: verticalGroupSize,
                                                              subitems: [miniGroup, miniGroup1])
        
        let verticalGroupSize1 = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5),
                                                        heightDimension: .fractionalHeight(1.0))
        
        let verticalGroup1 = NSCollectionLayoutGroup.horizontal(layoutSize: verticalGroupSize1,
                                                              subitems: [miniGroup1, miniGroup])
        

        let containerGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                        heightDimension: .fractionalHeight(1.2))
        
        let containerGroup = NSCollectionLayoutGroup.horizontal(layoutSize: containerGroupSize,
                                                              subitems: [verticalGroup, verticalGroup1])
        
        let section = NSCollectionLayoutSection(group: containerGroup)
        
        return section
    }
}
