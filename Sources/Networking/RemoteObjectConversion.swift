//
//  File.swift
//  
//
//  Created by Paul on 22/05/2023.
//

import Foundation

public protocol RemoteObjectConversion {
    
    mutating func convertObjects<ModelObject: Decodable, DomainObject>(from modelType: ModelObject.Type, to domainType: DomainObject.Type, completion: @escaping ((Result<DomainObject, Error>)-> Void), domainsFactory: @escaping (ModelObject) -> DomainObject)
}
