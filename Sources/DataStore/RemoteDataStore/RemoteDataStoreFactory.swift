//
//  File.swift
//  
//
//  Created by Paul on 22/05/2023.
//

import Foundation
import Networking
import Resource

public protocol RemoteDataStoreFactoryProtocol {
    
    func makeRemoteDataStore<Model: Codable,Domain: Resource>(Model: Model.Type, Domain: Domain.Type,url: URL) -> DataStoreProtocol
}

public class RemoteDataStoreFactory: RemoteDataStoreFactoryProtocol {
    
    private let domainConverter: DomainObjectConversion
    
    public init(domainConverter: DomainObjectConversion) {
        self.domainConverter = domainConverter
    }
    
    public func makeRemoteDataStore<Model: Codable,Domain: Resource>(Model: Model.Type, Domain: Domain.Type, url: URL) -> DataStoreProtocol {
        
        let remoteConverter = makeRemoteConverter(url: url)
        
        return RemoteDataStore<Model, Domain>(remote: remoteConverter,
            domainConverter: domainConverter)
    }
    
    private func makeRemoteConverter(url: URL) -> RemoteObjectConversion {
        let networkManager = makeNetworkManager(url: url)
        return RemoteObjectConverter(networkManager: networkManager)
    }
    
    private func makeNetworkManager(url: URL) -> NetworkingManager {
        return DataTaskNetworkManager(url: url)
    }
}
