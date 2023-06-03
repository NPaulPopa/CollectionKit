//
//  File.swift
//  
//
//  Created by Paul on 22/05/2023.
//

import Foundation

public protocol LocalDataStoreFactoryProtocol {
    func makeFileManagerDataStore() -> DataStoreProtocol
}

public class FileManagerDataStoreFactory: LocalDataStoreFactoryProtocol {

    public init() { }
    
    public func makeFileManagerDataStore() -> DataStoreProtocol {
        return FileManagerDataStore()
    }
}
