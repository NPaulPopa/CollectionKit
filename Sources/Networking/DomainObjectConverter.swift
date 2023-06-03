//
//  File.swift
//  
//
//  Created by Paul on 22/05/2023.
//

import Foundation

public struct DomainObjectConverter<Model, Domain>: DomainObjectConversion {

    let domainFactory: (Model) -> Domain

    public init(domainFactory: @escaping (Model) -> Domain) {
        self.domainFactory = domainFactory
    }
    
    public func getDomains<ModelType, Domain>(from models: [ModelType]) -> [Domain] {
        return models.compactMap { (user: ModelType) in
            return domainFactory(user as! Model) as? Domain
        }
    }
}


public struct DomainObjectConverterSecondVersion: DomainObjectConversion {
    
    typealias DomainConversionClosure = ([Any]) -> [Any]
    private let domainConversionFactory: DomainConversionClosure
        
    public init<Model, Domain>(domainConversionClosure: @escaping ([Model]) -> [Domain]) {
        
        domainConversionFactory = { models in
            let convertedModels = models.compactMap { $0 as? Model }
            let convertedDomains = domainConversionClosure(convertedModels)
            return convertedDomains
        }
    }
    
    public func getDomains<ModelType, DomainType>(from models: [ModelType]) -> [DomainType] {
        
        return domainConversionFactory(models) as! [DomainType]
    }
}













public struct DomainObjectConverterFirstVersion: DomainObjectConversion {

    public init() { }
    
    public func getDomains<Model, Domain>(from models: [Model]) -> [Domain] {
                
        return models.compactMap { (user: Model) in
                        
            //TODO: Create a closure that gets called and we pass in the Model
            fatalError()
     /*   guard let user = user as? UserModel,
              
              let domainUsers =
                
           //     Store(id: String(user.id), name: user.name, isSelected: false)
                
                DomainUser(
                id: String(user.id),
                name: user.name,
                isSelected: false,
                streetName: user.address.street,
                phone: user.phone,
                website: user.website,
                companyName: user.company.name,
                companyDescription: user.company.bs)
                
                as? Domain else { fatalError() }
                        
            return domainUsers
            */
        }
    }
    
    public func getDomain<Model, Domain>(from model: Model) -> Domain {
        
        fatalError()
        
      /*  guard let user = model as? UserModel,
                                
           let domainUser = DomainUser(
                id: String(user.id),
                name: user.name,
                isSelected: false,
                streetName: user.address.street,
                phone: user.phone,
                website: user.website,
                companyName: user.company.name,
                companyDescription: user.company.bs)
                as? Domain else { fatalError() }
            
            return domainUser
        */
    }
}
