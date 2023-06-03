//
//  File.swift
//  
//
//  Created by Paul on 22/05/2023.
//

import UIKit
import Resource
import Repository

public class GenericDataSourceDelegate<ItemModel,CellVM>: DataSourceDelegate where CellVM: CellViewModel, ItemModel: Resource {
    
    private var cellViewModel: CellViewModel!
        
    //MARK: - Properties
    
    let cellViewModelFactory: CellViewModelFactory<ItemModel,CellVM>

    weak public var diffableDataSource: DataSourceProtocol?
    private let repository: RepositoryProtocol
    
    //MARK: - Initializer
 
    public init(repository: RepositoryProtocol,
                CellViewModelType: CellVM.Type) {
        
        self.repository = repository
        self.cellViewModelFactory = CellViewModelFactory()
    }
    
    //MARK: This is configuring the cells
    
    public func configureViewModel(id: String, cell: GenericCell, component: GenericComponent, indexPath: IndexPath, genericDelegate: CollectionDelegateProtocol?) {
        
        guard let item: ItemModel = repository.getItem(at: id) else { return }
                        
        let cellViewModel = cellViewModelFactory.cellViewModel(item)
            //GenericCellViewModel<ItemModel>(resource: item)
        
        cellViewModel.configureCellViewModel(cell, in: component, for: indexPath, genericDelegate: genericDelegate)
            
       /*
        if self.cellViewModel == nil {
        self.cellViewModel = cellViewModel
        
        } else {
            cellViewModel.updateResource(using: item)
        }
        */
        //cellViewModelFactory.cellViewModel(item)
        
    }
    
    //MARK: - Delegate Methods
    
    public func didSelectItemIdentifier(for cell: GenericCell, at indexPath: IndexPath, in component: GenericComponent) {
        
        guard let diffableDataSource = diffableDataSource,
              let selectedID = diffableDataSource.getItemIdentifier(for: indexPath)
        else { return }
        
        guard let selectedItem: ItemModel = repository.getItem(at: selectedID) else { return }
        
        

     /*   if self.cellViewModel == nil {
            
           // let cellViewModel = GenericCellViewModel<ItemModel>(resource: selectedItem)

            self.cellViewModel = cellViewModel //as! CellViewModelNew
            
        } else {
            cellViewModel.updateResource(using: selectedItem)
        }
      */
        
        let cellViewModel = cellViewModelFactory.cellViewModel(selectedItem)
        
        let updatedItemModel: ItemModel = cellViewModel.getUpdatedResource(cell, in: component, for: indexPath)

        repository.updateItem(nil,updatedItem: updatedItemModel)
        
//        guard let selectedItem: ItemModel = repository.getItem(at: selectedID) else { return }
        
       // let cellViewModel = cellViewModelFactory.cellViewModel(selectedItem)
                                
//        let updatedItemModel: ItemModel = cellViewModel.getUpdatedResource(cell, in: component, for: indexPath)

//        repository.updateItem(nil,updatedItem: updatedItemModel)

        var newSnaphot = diffableDataSource.makeSnapshot()
        
        if #available(iOS 15, *) {
            newSnaphot.reconfigureItems([selectedID])
            
        } else { // ios 14
            newSnaphot.reloadItems([selectedID])
        }
        
        diffableDataSource.applySnapshot(newSnaphot, animatingDifferences: true, completion: nil)
    }
}


