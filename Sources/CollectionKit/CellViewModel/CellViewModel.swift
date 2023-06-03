//
//  File.swift
//  
//
//  Created by Paul on 22/05/2023.
//

import UIKit
import Resource

open class GenericCellViewModel<ItemModel: Resource>: CellViewModel {
   
    //MARK: - Properties

    private var resource: ItemModel
    
    required public init<Item>(resource: Item) {
        self.resource = resource as! ItemModel
    }
    
    public func updateResource<Item: Resource>(using item: Item) {
        self.resource = item as! ItemModel
    }
    
    //MARK: - Get Resource
    
    public func getResource<Item: Resource>() -> Item {
        guard let resource = resource as? Item else {
            preconditionFailure("Item and ItemModel must be the same type")
        }
        return resource
    }
    
    //MARK: - Get Updated Resource
    
    public func getUpdatedResource<Item: Resource>(_ cell: GenericCell, in component: GenericComponent, for indexPath: IndexPath) -> Item {
        
        guard var resource = resource as? Item else {
            preconditionFailure("Item and ItemModel must be the same type")
        }
        resource.isSelected.toggle()
        return resource
    }
    
    //MARK: - Configure Cell

    public func configureCellViewModel(_ cell: GenericCell, in component: GenericComponent, for indexPath: IndexPath, genericDelegate: CollectionDelegateProtocol?) {
        
        if let cell = cell as? CollectionCell<ItemModel> {
            configureComponent(for: cell, in: component, at: indexPath, using: genericDelegate)
        }
    }
    
    private func configureComponent<Cell: CellConfiguration>(for cell: Cell, in component: GenericComponent, at indexPath: IndexPath, using genericDelegate: CollectionDelegateProtocol?) where Cell.T == ItemModel {
                    
        cell.setupCell(with: resource)
        cell.configureConstrainCell()
        cell.isSelected(resource: resource)
                   
        guard let genericDelegate = genericDelegate else { return }

        cell.configureTappedCell(status: indexPath.row == genericDelegate.selectedIndex)
                
        if genericDelegate.shouldRepondToUserInteraction {
            setupDelegate(for: cell, in: component)
        }
        
        if genericDelegate.shouldResetCell {
            cell.resetCell(status: genericDelegate.shouldResetCell)
        }
        
        if genericDelegate.shouldRestoreCell {
            cell.restoreCell(status: false)
        }
        
        if genericDelegate.shouldHighlightCell {
            cell.shouldHighlightCell(status: true)
            
        } else if genericDelegate.shouldHighlightCell == false {
            cell.shouldHighlightCell(status: false)
        }
        
        publicComponentConfiguration(for: cell, in: component, at: indexPath, using: genericDelegate)
    }
        
    private func setupDelegate<Cell: CellConfiguration>(for cell: Cell, in component: GenericComponent)   {
        
        guard let collection = component as? GenericCellDelegate,
              var genericCell = cell as? GenericCell else {

                  let message = "Check if CollectionView conforms to GenericCellDelegate and CollectionCell has a delegate property: "
                  let errorContent = message + String(describing: type(of: cell)) + ", " + String(describing: type(of: component))

                fatalError(errorContent)

                }
        
        genericCell.delegate = collection
    }
    
    //MARK: Overridable Methods
     
     ///Allows subclasses to access each cell as it is being dequed
     open func publicComponentConfiguration<Cell: CellConfiguration>(for cell: Cell, in component: GenericComponent, at indexPath: IndexPath, using genericDelegate: CollectionDelegateProtocol?) where Cell.T == ItemModel {

         // Subclasses to provide needed functionality
     }
}
