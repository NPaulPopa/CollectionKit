//
//  File.swift
//  
//
//  Created by Paul on 22/05/2023.
//

import UIKit

public protocol CollectionSelectionDelegate: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
            
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath)
}

public extension CollectionSelectionDelegate {
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) { fatalError() }
}

open class GenericCollectionDelegate<ItemModel>: NSObject, UICollectionViewDelegate, CollectionDelegateProtocol {
    
    public override init() {   }

    //MARK: - Properties
        
    public var selectedIndex: Int?
    
    public var shouldRestoreCell: Bool = false
    public var shouldHighlightCell: Bool = false
    public var shouldRepondToUserInteraction: Bool = false
    
    public var hasDeselectedItem: Bool = false
    public var shouldAllowDeselection: Bool = false
    public var shouldResetCell: Bool = false
    
    weak public var dataSourceDelegate: DataSourceDelegate?
    weak public var selectionDelegate: CollectionSelectionDelegate?
        
    //MARK: - Selection Methods
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        configureTappedCell(collectionView, at: indexPath)
    }
    
    public func configureTappedCell(_ collectionView: UICollectionView, at indexPath: IndexPath) {
        
        guard let cell = collectionView.cellForItem(at: indexPath) as? CollectionCell<ItemModel> else { return }

        dataSourceDelegate?.didSelectItemIdentifier(for: cell, at: indexPath, in: collectionView)

        selectionDelegate?.collectionView(collectionView, didSelectItemAt: indexPath)

        let generator = UIImpactFeedbackGenerator(style: .soft)
        generator.impactOccurred()

        collectionView.deselectItem(at: indexPath, animated: true)

        configureCellState(in: collectionView,for: indexPath)
    }
    
    //MARK: - Deselection Methods

    public func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {

        if shouldDeselectCell(at: indexPath) && shouldAllowDeselection {
            
            shouldResetCell.toggle()
            collectionView.reloadData()
           
            selectionDelegate?.collectionView(collectionView, didDeselectItemAt: indexPath)

            return false
        }
       
        return true
    }
    
    //MARK: - Private Methods

    private func shouldDeselectCell(at indexPath: IndexPath) -> Bool {
        
        guard let selectedIndex = selectedIndex,
              selectedIndex == indexPath.item && !hasDeselectedItem
                
        else {
            hasDeselectedItem = false
            return false
        }
        
        hasDeselectedItem = true
        return true // when goo returns true from the first tap
    }
    
    private func configureCellState(in collectionView: UICollectionView ,for indexPath: IndexPath) {
        
        self.selectedIndex = indexPath.item

        if shouldResetCell {
            shouldResetCell.toggle()
        }
        
        if shouldRestoreCell {
            shouldRestoreCell.toggle()
        }
        
        collectionView.reloadData()
    }
}

public protocol CollectionDelegateProtocol: UICollectionViewDelegate {
    
    var selectedIndex: Int? { get set }

    var shouldRestoreCell: Bool { get set }
    var shouldResetCell: Bool { get set }

    var shouldHighlightCell: Bool { get set }
    var shouldRepondToUserInteraction: Bool { get set }
    
    var hasDeselectedItem: Bool { get set }
    var shouldAllowDeselection: Bool { get set }
    
    var dataSourceDelegate: DataSourceDelegate? { get set }
    var selectionDelegate: CollectionSelectionDelegate? { get set }
}

public protocol DataSourceDelegate: AnyObject {
    
    var diffableDataSource: DataSourceProtocol? { get set }
    func didSelectItemIdentifier(for cell: GenericCell, at indexPath: IndexPath, in component: GenericComponent)
    
    func configureViewModel(id: String, cell: GenericCell, component: GenericComponent, indexPath: IndexPath, genericDelegate: CollectionDelegateProtocol?)
}

//MARK: - DataSource Protocol
public protocol DataSourceProtocol: AnyObject {
    
    func makeSnapshot() -> NSDiffableDataSourceSnapshot<String, String>
    func getItemIdentifier(for indexPath: IndexPath) -> String?
    func applySnapshot(_ snapshot: NSDiffableDataSourceSnapshot<String, String>, animatingDifferences: Bool, completion: (() -> Void)?)
}




