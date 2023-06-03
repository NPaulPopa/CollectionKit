//
//  File.swift
//  
//
//  Created by Paul on 22/05/2023.
//

import Foundation

public protocol DomainObjectConversion {
        
    func getDomains<Model, Domain>(from models: [Model]) -> [Domain]
    func getDomain<Model, Domain>(from model: Model) -> Domain
}

extension DomainObjectConversion {
    
    public func getDomain<Model, Domain>(from model: Model) -> Domain
    { fatalError() }
}
