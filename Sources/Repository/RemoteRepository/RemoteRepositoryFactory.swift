//
//  File.swift
//  
//
//  Created by Paul on 22/05/2023.
//

import Foundation
import Networking
import DataStore
import Resource

public class RemoteRepositoryFactory<Converter: DomainConverter,Model: Codable,Domain: CodableResource> where Converter.Model == Model, Converter.Domain == Domain {
    
    //MARK: Properties

    let url: URL

    public init(url: URL) {
        self.url = url
    }
    
    //MARK: Repository

    public func makeRemoteRepository() -> RepositoryProtocol {
        let remoteDataStore = makeRemoteDataStore(url: url)
        return RemoteRepository<Domain>(dataStore: remoteDataStore)
    }
    
    //MARK: DomainObject Converter
    
    private func makeDomainObjectConverter() -> DomainObjectConversion {
        
        let domainConverter = Converter()
        return DomainObjectConverter<Model, Domain>(
            domainFactory: domainConverter.convertModelToDomain(_:))
    }
    
    //MARK: RemoteDataStore

    private func makeRemoteDataStore(url: URL) -> DataStoreProtocol {
                
        let dataStoreFactory = makeDataStoreFactory()
        let dataStore = dataStoreFactory.makeRemoteDataStore(Model: Model.self, Domain: Domain.self, url: url)
        
        return dataStore
    }
    
    //MARK: RemoteDataStore Factory

    private func makeDataStoreFactory() -> RemoteDataStoreFactoryProtocol {
        
        let domainConverter = makeDomainObjectConverter()
        let dataStoreFactory = RemoteDataStoreFactory(domainConverter: domainConverter)
        
        return dataStoreFactory
    }
}

public protocol DomainConverter {
    
    associatedtype Model
    associatedtype Domain
    
    init()
    func convertModelToDomain(_ user: Model) -> Domain
}
