//
//  GenericLocalRepository.swift
//  
//
//  Created by Paul on 22/05/2023.
//

import Foundation
import Resource
import DataStore

public class LocalRepository<ItemModel: CodableResource>: RepositoryProtocol {
   
    public func getCachedItems<Item: Resource>() -> [Item] {
       
        if let itemsArray = itemsArray as? [Item]{
            return itemsArray
        }
        fatalError("Could not cast from ItemModel to Item")
    }
    
    public func getCachedIDictionary<Item: Resource>() -> [String : Item] {
        if let itemsDictionary = itemDictionary as? [String:Item]{
            return itemsDictionary
        }
        fatalError("Could not cast from ItemModel to Item")
    }
    
    //MARK: - Properties

    var itemDictionary: [String : ItemModel] = [:]
    var itemsArray: [ItemModel] = []
    var dataStore: DataStoreProtocol

    //MARK: - Initializer

    public init(dataStore: DataStoreProtocol) {
        self.dataStore = dataStore
    }
    
    //MARK: - GetItem at ID
    public func getItem<Item>(at id: String) -> Item? {
        if let itemsDictionary = itemDictionary as? [String: Item] {
            return itemsDictionary[id]
        }
        fatalError("Could not cast from ItemModel to Item")
    }
    
    //MARK: Add new Item
    public func addNewItem<Item: Resource>(_ newItem: Item) {
        
        if let newItem = newItem as? ItemModel {
            itemDictionary[newItem.id] = newItem
            itemsArray.append(newItem)
        }
    }
    
    //MARK: - Add Multiple Items
    
    public func addItems<Item: CodableResource>(_ items: [Item]) {
        
        if let newItems = items as? [ItemModel] {
            
        itemsArray.append(contentsOf: newItems)
            dataStore.saveItems(newItems) { result in
                if case .success = result {
                    print("Succesffuly added a bunch of items")
                }
            }
        }
    }
    
    //MARK: Remove Item
    public func removeItem<Item: Resource>(_ itemToDelete: Item) {
        self.itemDictionary.removeValue(forKey: itemToDelete.id)
        itemsArray.removeAll(where: {$0.id == itemToDelete.id })
    }
    
    //MARK: NEW Update Item TODO: Break it down in 2 methods
    public func updateItem<Item>(_ existingItemID: String?, updatedItem: Item) {
        
        guard let updatedItem = updatedItem as? ItemModel else { return }
        
        if let existingItemID = existingItemID {
            itemDictionary[existingItemID] = updatedItem
        } else {
            itemDictionary[updatedItem.id] = updatedItem
        }
    }
    
    //MARK: Get ItemIDs
    public func getItemIdentifiers() -> [String]? { //TODO: return an array of String
        
        guard let items: [ItemModel] = dataStore.getItemsArray() else { return nil }
        
        self.createItemsTupleArray(fromLists: items)
        self.store(items: items)
        return items.map {$0.id}
    }
    
    //MARK: Get Single ItemIDs
    public func getSingleItemIdentifier() -> String? {
        
        guard let item: ItemModel = dataStore.getSingleItem() else { return nil }
        
        createSingleItemTupleArray(from: item)
        return item.id
    }
    
    //MARK: Fetch ItemIdentifiers from FileManager
    public func getItemIdentifiers(completion: @escaping (Result<[String], Error>) -> Void) {
        
        dataStore.fetchItems { [weak self] (result: Result<[ItemModel], Error>) in
            guard let self = self else { return }

            switch result {
            case .success(let items):
                
                self.createItemsTupleArray(fromLists: items)
                self.store(items: items)
                
                print(items.first!.id)
                let identifiers = items.map { $0.id }
                completion(.success(identifiers))
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    //MARK: Fetch SingleItem Identifier from FileManager
    public func getSingleItemIdentifier(completion: @escaping (Result<String, Error>) -> Void) {
        
        dataStore.fetchSingleItem { [weak self] (result: Result<ItemModel, Error>) in
            
            guard let self = self else { return }
            
            switch result {
                
            case .success(let item):
            self.createSingleItemTupleArray(from: item)
            self.itemsArray.append(item)
                
            let itemIdentifier = item.id
            completion(.success(itemIdentifier))
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    //MARK: Get ItemsDictionary
    public func getItemsDictionary<Item>(completion: @escaping (Result<[String : Item], Error>) -> Void) {
        
        if let itemDictionary = itemDictionary as? [String: Item] {
            completion(.success(itemDictionary))
        }
    }
    
    //MARK: - Get ItemsArray Methods
    public func getItemsArray<Item>(completion: @escaping (Result<[Item], Error>) -> Void) {
        if let itemsArray = itemsArray as? [Item] {
            completion(.success(itemsArray))
        }
    }
}

//MARK: - Private Methods

extension LocalRepository {
        
    private func createItemsTupleArray(fromLists groceryListArray: [ItemModel]) {
        
        let itemTupleArray = groceryListArray.map { ($0.id, $0) }
        itemDictionary = Dictionary(uniqueKeysWithValues: itemTupleArray)
    }
    
    private func createSingleItemTupleArray(from item: ItemModel) {
        
        let itemTupleArray = (item.id, item)
        itemDictionary = Dictionary(uniqueKeysWithValues: [itemTupleArray])
    }
    
    private func store(items: [ItemModel]) {
        self.itemsArray = items
    }
}
