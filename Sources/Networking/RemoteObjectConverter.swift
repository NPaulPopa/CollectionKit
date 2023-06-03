//
//  File.swift
//  
//
//  Created by Paul on 22/05/2023.
//

import Foundation

public struct RemoteObjectConverter: RemoteObjectConversion {

    var networkManager: NetworkingManager
    
    public init(networkManager: NetworkingManager) {
        self.networkManager = networkManager
    }
    
    public mutating func convertObjects<ModelObject: Decodable, DomainObject>(from modelType: ModelObject.Type, to domainType: DomainObject.Type, completion: @escaping ((Result<DomainObject, Error>)-> Void), domainsFactory: @escaping (ModelObject) -> DomainObject) {
                 
        networkManager.downloadObject(ofType: ModelObject.self) { result in
            
            switch result {
                
            case .success(let modelObjects):
                
                let domainObjects: DomainObject = domainsFactory(modelObjects)
                completion(.success(domainObjects))
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
     }
}
