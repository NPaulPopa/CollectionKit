//
//  File.swift
//  
//
//  Created by Paul on 22/05/2023.
//

import Foundation
import Combine

//TODO: - Extract it inside its own Networking Module

public protocol NetworkingManager {
    
    mutating func downloadObject<ModelObject: Decodable>(ofType modelType: ModelObject.Type, completion: @escaping ((Result<ModelObject, Error>)-> Void))
}

public struct DataTaskNetworkManager: NetworkingManager {
    
    let url: URL
    var cancellables = Set<AnyCancellable>()
    
    public init(url: URL) {
        self.url = url
    }
    
    public mutating func downloadObject<ModelObject: Decodable>(ofType modelType: ModelObject.Type, completion: @escaping ((Result<ModelObject, Error>)-> Void)) {
                 
        URLSession.shared.dataTaskPublisher(for: url)
            .subscribe(on: DispatchQueue.global(qos: .background), options: nil)
            .receive(on: DispatchQueue.main, options: nil)
            .sink(receiveCompletion: { result in
                 if case let .failure(error) = result {
                     completion(.failure(error))
                 }
             }, receiveValue: {
                                  
                 completion(.success($0))
             })
            .store(in: &cancellables)
     }
}
