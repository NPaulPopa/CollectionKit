//
//  File.swift
//  
//
//  Created by Paul on 22/05/2023.
//

import Foundation
import Networking
import Combine

/// Generic Remote Data Store that returns item identifiers for a given URL
/// - ModelType: Decodable - Data Model that remote data is being decoded into from the server
/// -  DomainType: The specific domain we want to convert the Model into
public class RemoteDataStore<ModelType: Decodable, DomainType>: DataStoreProtocol {
    
    public func getItemsArray<Item>() -> [Item]? {
        fatalError()
    }
    
    public func getSingleItem<Item>() -> Item? {
        fatalError()
    }
    
    
    var remote: RemoteObjectConversion
    let domainConverter: DomainObjectConversion
        
    public init(remote: RemoteObjectConversion,
         domainConverter: DomainObjectConversion) {
        self.domainConverter = domainConverter
        self.remote = remote
    }
    
    //MARK: - Get Remote Items Array
    
    public func fetchItems<Item>(completion: @escaping (Result<[Item], Error>) -> Void) {
        
        remote.convertObjects(from: [ModelType].self, to: [DomainType].self) { result in
            
            switch result {
                
            case .success(let domainObjects):
                guard let domainObjects = domainObjects as? [Item] else { return }
                completion(.success(domainObjects))
                
            case .failure(let error):
                completion(.failure(error))
            }
        } domainsFactory: { self.domainConverter.getDomains(from: $0) }
    }
    
    //MARK: - Get Remote Single Item
    
    public func fetchSingleItem<Item>(completion: @escaping ((Result<Item, Error>) -> Void)) {
        
        remote.convertObjects(from: ModelType.self, to: DomainType.self) { result in

            switch result {

            case .success(let domainObject):
                guard let domainObject = domainObject as? Item else { return }
                completion(.success(domainObject))

            case .failure(let error):
                completion(.failure(error))
            }
        } domainsFactory: { self.domainConverter.getDomain(from: $0) }
    }
    
    public func saveItems<Item: Codable>(_ items: [Item], completion: @escaping (Result<Bool, Error>) -> Void) {
        
        fatalError("NOT YET IMPLEMENTED saving items to DB")
    }
    
    public func saveSingleItem<Item: Codable>(_ item: Item) {
        fatalError("NOT YET IMPLEMENTED saving single item to DB")
    }
}
