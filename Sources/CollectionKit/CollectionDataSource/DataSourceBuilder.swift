//
//  File.swift
//  
//
//  Created by Paul on 22/05/2023.
//

import Foundation
import Resource
import Repository

public class GenericDataSourceBuilder<Cell,ItemModel,CellVM> where Cell: CollectionCell<ItemModel>,CellVM: CellViewModel, ItemModel: CodableResource {
    
    //MARK: - Properties
        
    private let repository: RepositoryProtocol
    private let genericDelegate: CollectionDelegateProtocol
    
    //MARK: - Initializer

    public init(_ repository: RepositoryProtocol,
                _ genericDelegate: CollectionDelegateProtocol) {
        
        self.repository = repository
        self.genericDelegate = genericDelegate
    }
    
    //MARK: - DataSource Factory

    public func makeGenericDataSource() -> GenericCollectionDataSourceProtocol {
        
        let genericDataSource = GenericCollectionDataSource<Cell, ItemModel>(dataSourceDelegate: makeDataSourceDelegate())
        
        genericDataSource.genericDelegate = genericDelegate
        genericDelegate.dataSourceDelegate = genericDataSource.dataSourceDelegate
                
        return genericDataSource
    }
    
    //MARK: - DataSourceDelegate Factory

    private func makeDataSourceDelegate() -> DataSourceDelegate {
        
        return GenericDataSourceDelegate<ItemModel, CellVM>(repository: repository, CellViewModelType: CellVM.self)
    }
    
    public func getDelegate() -> CollectionDelegateProtocol {
        return genericDelegate
    }
}
