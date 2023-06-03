//
//  File.swift
//  
//
//  Created by Paul on 21/05/2023.
//

import UIKit

public protocol GenericCollectionDataSourceProtocol: AnyObject {
    
    var collectionView: UICollectionView! { get set }
    var genericDelegate: CollectionDelegateProtocol? { get set }
    var dataSourceDelegate: DataSourceDelegate? { get }

    func getDiffableDataSource() -> UICollectionViewDiffableDataSource<String, String>?
    
    func configureDiffableDataSource(_ items: [String])
}

public class GenericCollectionDataSource<Cell:CollectionCell<ItemModel>,ItemModel>: GenericCollectionDataSourceProtocol {
    
    public func getDiffableDataSource() -> UICollectionViewDiffableDataSource<String, String>? {
        
        //TODO: Either use it inside GenericCollectionView or delete it altogetherx
       
        return diffableDataSource
    }

    //MARK: - Properties

    public var diffableDataSource: UICollectionViewDiffableDataSource<String, String>!
    
    public weak var collectionView: UICollectionView!
    public var dataSourceDelegate: DataSourceDelegate?
    public var genericDelegate: CollectionDelegateProtocol?

    //MARK: - Initializer

    public init(dataSourceDelegate: DataSourceDelegate) {
        self.dataSourceDelegate = dataSourceDelegate
        dataSourceDelegate.diffableDataSource = self
    }
    
    //MARK: - Diffable DataSource

    public func configureDiffableDataSource(_ items: [String]) {

        diffableDataSource = UICollectionViewDiffableDataSource<String, String>(collectionView: collectionView, cellProvider: { collectionView, indexPath, id -> UICollectionViewCell? in
            
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Cell.cellReuseIdentifier, for: indexPath) as? Cell
            else { return UICollectionViewCell() }
        
            self.dataSourceDelegate?.configureViewModel(id: id, cell: cell, component: collectionView, indexPath: indexPath, genericDelegate: self.genericDelegate)

        return cell

        })
        
        var snapshot = NSDiffableDataSourceSnapshot<String, String>()
        snapshot.appendSections(["main"])
        snapshot.appendItems(items, toSection: "main")
        diffableDataSource.apply(snapshot, animatingDifferences: false)
    }
}


//MARK: - DataSource Protocol Methods

extension GenericCollectionDataSource: DataSourceProtocol {
    
    public func makeSnapshot() -> NSDiffableDataSourceSnapshot<String, String> {
        diffableDataSource.snapshot()
    }
    
    public func getItemIdentifier(for indexPath: IndexPath) -> String? {
        diffableDataSource.itemIdentifier(for: indexPath)
    }
    
    public func applySnapshot(_ snapshot: NSDiffableDataSourceSnapshot<String, String>, animatingDifferences: Bool, completion: (() -> Void)?) {
        diffableDataSource.apply(snapshot)
    }
}
