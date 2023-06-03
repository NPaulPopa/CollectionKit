//
//  File.swift
//  
//
//  Created by Paul on 22/05/2023.
//

import Foundation
import Resource
import DataStore

public protocol LocalRepositoryFactoryProtocol {
    func makeLocalRepository(dataStore: DataStoreProtocol) -> RepositoryProtocol
}

public class LocalRepositoryFactory<Model: CodableResource,Domain: Resource>: LocalRepositoryFactoryProtocol {
    
    public init() { }
    
    public func makeLocalRepository(dataStore: DataStoreProtocol) -> RepositoryProtocol {
        
        let localRepository = LocalRepository<Model>(dataStore: dataStore)
        return localRepository
    }
}
