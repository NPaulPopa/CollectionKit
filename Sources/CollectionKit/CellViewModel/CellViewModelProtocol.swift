//
//  File.swift
//  
//
//  Created by Paul on 22/05/2023.
//

import UIKit
import Resource

public protocol CellViewModel {
    
    init<Item>(resource: Item?)
    
    func getResource<Item: Resource>() -> Item
    
    mutating func updateResource<Item: Resource>(using item: Item)
                    
    func configureCellViewModel(_ cell: GenericCell, in component: GenericComponent, for indexPath: IndexPath, genericDelegate: CollectionDelegateProtocol?)
            
    func getUpdatedResource<Item: Resource>(_ cell: GenericCell, in component: GenericComponent, for indexPath: IndexPath) -> Item
}
