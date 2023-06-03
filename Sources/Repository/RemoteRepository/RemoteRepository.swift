//
//  File.swift
//  
//
//  Created by Paul on 22/05/2023.
//

import Foundation
import DataStore
import Resource
 
public class RemoteRepository<ItemModel: CodableResource>: RepositoryProtocol {
    
    //MARK: - Properties

    var itemDictionary: [String : ItemModel] = [:]
    var itemsArray: [ItemModel] = []
    var dataStore: DataStoreProtocol

    //MARK: - Initializer

    public init(dataStore: DataStoreProtocol) {
        self.dataStore = dataStore
    }
    
    public func getCachedItems<Item: CodableResource>() -> [Item] {
        
        if let itemsArray = itemsArray as? [Item]{
            return itemsArray
        }
        print("ERROR,the Item type is actually: \(Item.self)")
        print("AND,the ItemModel type is actually: \(ItemModel.self)")
        
        //ERROR,the Item type is actually: GroceryItem
        //AND,the ItemModel type is actually: DomainUser
        
        //In other words, we defined the type of this repository as being DomainUser and we're trying to store GroceryItems 
        
        fatalError("Could not cast from ItemModel to Item")
    }
    
    public func getCachedIDictionary<Item: Resource>() -> [String : Item] {
        if let itemsDictionary = itemDictionary as? [String:Item]{
            return itemsDictionary
        }
        fatalError("Could not cast from ItemModel to Item")
    }
    
    
    //MARK: - Get Item by ID

    public func getItem<Item>(at id: String) -> Item? {
        if let itemsDictionary = itemDictionary as? [String: Item]{
            return itemsDictionary[id]
        }
        print("ERROR,the Item type is actually: \(Item.self)")
        fatalError("Could not cast from ItemModel to Item")
    }
    
    //MARK: NEW Add new Item
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

    //MARK: NEW Remove Item
    public func removeItem<Item: Resource>(_ itemToDelete: Item) {
        self.itemDictionary.removeValue(forKey: itemToDelete.id)
        itemsArray.removeAll(where: {$0.id == itemToDelete.id })
    }
    
    //MARK: NEW Update Item
    public func updateItem<Item>(_ existingItemID: String?, updatedItem: Item) {
        
        guard let updatedItem = updatedItem as? ItemModel else { return }
        
        if let existingItemID = existingItemID {
            itemDictionary[existingItemID] = updatedItem
        } else {
            itemDictionary[updatedItem.id] = updatedItem
        }
    }
    
    //MARK: NEW Get ItemIDs
    public func getItemIdentifiers() -> [String]? { //TODO: return an array of String
        
//        guard let items: [ItemModel] = dataStore.getItemsArray() else { return nil }
        
        var returnedItems: [ItemModel] = []
        var returnedIDs: [String] = []
        
        
        dataStore.fetchItems { (result: Result<[ItemModel],Error>) in
            
            switch result {
            case .success(let items):
                returnedItems = items
                
                self.createItemsTupleArray(fromLists: items)
                self.store(items: items)
                returnedIDs = items.map {$0.id}
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        return returnedIDs
    }

    //MARK: NEW Get Single ItemIDs

    public func getSingleItemIdentifier() -> String? {
        
        guard let item: ItemModel = dataStore.getSingleItem() else { return nil }
        
        createSingleItemTupleArray(from: item)
        return item.id
    }
    
    //MARK: NEW Get RemoteItemIdentifiers
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
    
    //MARK: NEW Get Remote SingleItem Identifier
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
    
    //MARK: NEW Get ItemDictionary
    public func getItemsDictionary<Item>(completion: @escaping (Result<[String : Item], Error>) -> Void) {
        
        if let itemDictionary = itemDictionary as? [String: Item] {
            completion(.success(itemDictionary))
        }
    }

    //MARK: - NEW Get ItemArray Methods
    public func getItemsArray<Item>(completion: @escaping (Result<[Item], Error>) -> Void) {
        if let itemsArray = itemsArray as? [Item] {
            completion(.success(itemsArray))
        }
    }
    
    //MARK: - Private Methods
    
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
    
    private func findOldItemIndex<ItemModel>(in itemsArray: [ItemModel], using newItem: ItemModel) -> Int? where ItemModel: Identifiable, ItemModel.ID == String { //DOESN'T GET CALLED
        
        // transferred here from GroceryListCarousel
        
        if let oldItemIndex = itemsArray.firstIndex(where: { $0.id == newItem.id }) {
            return oldItemIndex
        }
        return nil
    }
}
