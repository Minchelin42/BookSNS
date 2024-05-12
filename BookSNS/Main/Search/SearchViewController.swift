//
//  SearchViewController.swift
//  BookSNS
//
//  Created by 민지은 on 2024/04/20.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import Kingfisher
import IQKeyboardManagerSwift

struct Post: Hashable, Identifiable {
    let id = UUID()
    
    let post_id: String
    let file_id: String
}

class SearchViewController: RxBaseViewController {
    
    let viewModel = SearchViewModel.shared
    let searchBar = UISearchBar()
    
    var item: [Post] = []
    
    enum Section: CaseIterable {
        case main
    }
    
    private lazy var collectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: .leftOneRightThree)
        view.delegate = self
        view.alwaysBounceVertical = true
        view.backgroundColor = .white
        view.register(SearchCollectionViewCell.self, forCellWithReuseIdentifier: SearchCollectionViewCell.identifier)
        
        return view
    }()
    
    var dataSource: UICollectionViewDiffableDataSource<Section, Post>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setConstraints()
        configureDataSource()
        updateSnapshot(item: [])
        
        navigationItem.titleView = searchBar
    }

    override func bind() {
        
        let input = SearchViewModel.Input(getPost: PublishSubject<Void>(), getSearchPost: PublishSubject<Void>(), searchText: PublishSubject<String>(), searchButtonClicked: searchBar.rx.searchButtonClicked)
        let output = viewModel.transform(input: input)
        
        searchBar.rx.placeholder.onNext("태그명 검색")

        searchBar.rx.searchButtonClicked
            .asDriver()
            .drive(with: self) { owner, _ in
                print("searchButtonClicked")
                IQKeyboardManager.shared.resignFirstResponder()
            }
            .disposed(by: disposeBag)
        
        searchBar.rx.text.orEmpty.changed
            .subscribe(with: self) { owner, text in
                input.searchText.onNext(text)
            }
            .disposed(by: disposeBag)

        viewModel.postResult
            .bind(with: self) { owner, result in
                owner.item.removeAll()
                for index in 0..<result.count {
                    let post = result[index]
                    if !post.files.isEmpty {
                        owner.item.append(Post(post_id: post.post_id, file_id: post.files[0]))
                    } else {
                        owner.item.append(Post(post_id: post.post_id, file_id: ""))
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
                    if owner.viewModel.isSearch {
                        input.getSearchPost.onNext(())
                    } else {
                        if !owner.viewModel.next_cursor.isEmpty {
                            input.getPost.onNext(())
                        }
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
        view.addSubview(searchBar)
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
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchCollectionViewCell.identifier, for: indexPath)

            MakeUI.loadImage(loadURL: MakeUI.makeURL(itemIdentifier.file_id), defaultImg: "defaultProfile") { image in
                (cell as? SearchCollectionViewCell)?.photoImageView.image = image
            }

            return cell
        })
    }
    
    
    private func updateSnapshot(item: [Post]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Post>()
        snapshot.appendSections(Section.allCases)
        snapshot.appendItems(item)
        dataSource.apply(snapshot)
    }
    
}

extension SearchViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let data = dataSource.itemIdentifier(for: indexPath) else {
            return
        }
        
        let vc = SelectPostViewController()
        vc.postID = data.post_id
        Transition.push(nowVC: self, toVC: vc)
    }
}

extension UICollectionViewLayout {
    static let leftOneRightThree = UICollectionViewCompositionalLayout { section, environment in
        
        let margin = 1.0
        
        let bigItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.3333),
                                                 heightDimension: .fractionalHeight(1.0))
        let bigItem = NSCollectionLayoutItem(layoutSize: bigItemSize)
        bigItem.contentInsets = NSDirectionalEdgeInsets(top: margin,
                                                        leading: margin,
                                                        bottom: margin,
                                                        trailing: margin)
        
        let firstMiniItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                       heightDimension: .fractionalHeight(0.5))
        let firstMiniItem = NSCollectionLayoutItem(layoutSize: firstMiniItemSize)
        firstMiniItem.contentInsets = NSDirectionalEdgeInsets(top: margin,
                                                              leading: margin,
                                                              bottom: margin,
                                                              trailing: margin)
        
        let secondMiniItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                        heightDimension: .fractionalHeight(0.5))
        let secondMiniItem = NSCollectionLayoutItem(layoutSize: secondMiniItemSize)
        secondMiniItem.contentInsets = NSDirectionalEdgeInsets(top: margin,
                                                               leading: margin,
                                                               bottom: margin,
                                                               trailing: margin)
        
        let miniGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.3333),
                                                   heightDimension: .fractionalHeight(1.0))
        let miniGroup = NSCollectionLayoutGroup.vertical(layoutSize: miniGroupSize,
                                                         subitems: [firstMiniItem, secondMiniItem])
        
        
        let topGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                  heightDimension: .fractionalHeight(0.5))
        let topGroup = NSCollectionLayoutGroup.horizontal(layoutSize: topGroupSize,
                                                          subitems: [bigItem, miniGroup, miniGroup])
        
        let bottomGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                     heightDimension: .fractionalHeight(0.5))
        let bottomGroup = NSCollectionLayoutGroup.horizontal(layoutSize: bottomGroupSize,
                                                             subitems: [miniGroup, miniGroup, bigItem])
        
        
        let containerGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                        heightDimension: .fractionalHeight(0.75))
        
        let containerGroup = NSCollectionLayoutGroup.vertical(layoutSize: containerGroupSize,
                                                              subitems: [topGroup, bottomGroup])
        
        let section = NSCollectionLayoutSection(group: containerGroup)
        
        return section
    }
}
