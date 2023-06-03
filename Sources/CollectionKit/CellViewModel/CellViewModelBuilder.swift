//
//  File.swift
//  
//
//  Created by Paul on 22/05/2023.
//

import UIKit
import Repository

public protocol CellViewModelBuilderProtocol {
    
    func configureViewModel(id: String, cell: GenericCell, component: GenericComponent, indexPath: IndexPath, genericDelegate: CollectionDelegateProtocol?)
}

public class GenericCellViewModelBuilderNew<ItemModel>:CellViewModelBuilderProtocol{
    
    //MARK: - Properties
    typealias CellViewModelFactory = (ItemModel) -> CellViewModel

    public let makeCellViewModel: (ItemModel) -> CellViewModel
    var repository: RepositoryProtocol

    //MARK: - Initializer
    public init(repository: RepositoryProtocol,
        makeCellViewModel: @escaping (ItemModel) -> CellViewModel) {
        self.repository = repository
        self.makeCellViewModel = makeCellViewModel
    }
    
    //MARK: - CellViewModel Methods
    
    public func configureViewModel(id: String, cell: GenericCell, component: GenericComponent, indexPath: IndexPath,genericDelegate: CollectionDelegateProtocol?) {

        guard let item: ItemModel = repository.getItem(at: id) else { return }
        
        let cellViewModel = makeCellViewModel(item)
        
        cellViewModel.configureCellViewModel(cell, in: component, for: indexPath, genericDelegate: genericDelegate)
    }
}
