//
//  ListChannelViewController.swift
//  PinkBook
//
//  Created by mac on 2023/5/15.
//

import UIKit
import JXSegmentedView

class ListChannelViewController: UIViewController {
    
    var channels = ""
    var subChannels: [String] = []
    
    enum Section: Int {
        case all
    }
    
    enum Item: Hashable {
        case title
    }
    
    
    var dataSource: UICollectionViewDiffableDataSource<Section, Item>! = nil
    var collectionView: UICollectionView! = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        creatCollectionView()
        
        setupDataSource()
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections([.all])
        snapshot.appendItems([.title], toSection: .all)
        self.dataSource.apply(snapshot)
    }
    
    func creatCollectionView() {
        self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: generateLayout())
        self.collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view.addSubview(collectionView)
        
        self.collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.collectionView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.collectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.collectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
    }

    func generateLayout() -> UICollectionViewLayout {
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(44)))
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(44))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 20, trailing: 20)
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    func setupDataSource() {
        
        let item = UICollectionView.CellRegistration<ChannelCollectionViewCell, Item> { cell, indexPath, itemIdentifier in
            cell.imageView.image = UIImage(systemName: "number")
            cell.titleLabel.text = self.subChannels[indexPath.item]
            cell.titleLabel.font = .myFont(ofSize: 14, weight: .regular)
        }
        
        let dataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
            return collectionView.dequeueConfiguredReusableCell(using: item, for: indexPath, item: itemIdentifier)
        }
        
        self.dataSource = dataSource
    }



}

extension ListChannelViewController: JXSegmentedListContainerViewListDelegate {
    func listView() -> UIView {
        return view
    }
    
    
}
