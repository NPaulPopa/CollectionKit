//
//  File.swift
//  
//
//  Created by Paul on 22/05/2023.
//

import Foundation
import Combine
import Resource

/// Uses only generic functions and can be used as a Type as it doesn't have an associatedType
public protocol RepositoryProtocol {
        
    func addNewItem<Item: Resource>(_ newItem: Item)
    func addItems<Item: CodableResource>(_ items: [Item])
    func removeItem<Item: Resource>(_ itemToDelete: Item)
    
    func getCachedItems<Item: CodableResource>() -> [Item]
    func getCachedIDictionary<Item: CodableResource>() -> [String:Item]

    /// Required Method for replacing the stored item inside itemsDictionary with the updating item
    func updateItem<Item>(_ existingItemID: String?, updatedItem: Item)

    /// Required Method for returning the stored item itemsDictionary at the id location
    func getItem<Item>(at id: String) -> Item?
    func getItemIdentifiers() -> [String]?
    func getSingleItemIdentifier() -> String?

    func getItemsDictionary<Item>(completion: @escaping (Result<[String : Item], Error>) -> Void)
    
    func getItemsArray<Item>(completion: @escaping (Result<[Item], Error>) -> Void)
    
    func getItemIdentifiers(completion: @escaping (Result<[String],Error>) -> Void)
    func getSingleItemIdentifier(completion: @escaping(Result<String,Error>) -> Void)
}

/* Methods that are used everywhre
            REPOSITORY                              DATASTORE
 1. func getItemIdentifiers() -> [String]? -> func getItemsArray<Item>() -> [Item]?

 2. func getItemsArray<Item>(            -> Returns itemsArray inside Repository
 completion: @escaping
 (Result<[Item], Error>) -> Void)

 3. func getItemsDictionary<Item>        -> Returns itemsDictionary inside Repository
 (completion: @escaping
 (Result<[String : Item], Error>) -> Void)
 
 4.func getItemIdentifiers(              -> func fetchItems<Item:
 completion: @escaping                        Codable>(completion: @escaping
 (Result<[String],Error>) -> Void)            (Result<[Item],Error>) -> Void)
     
 
                                MUST HAVES
 
 // CellViewModelBuilder USES
 
 5. func getItem<Item>       -> Returns itemDictionary[id] inside Repository
 (at id: String) -> Item?
 
 // GenericDataSourceDelegate USES
 
 6. func getItem<Item>       -> Returns itemDictionary[id] inside Repository
 (at id: String) -> Item?

 7. func updateItem<Item>(   -> Updates itemDictionary[existingItemID] = updatedItem
 _ existingItemID: String?,             inside Repository
    updatedItem: Item)

 8 Generic collection view uses all the other repository methods
 */
