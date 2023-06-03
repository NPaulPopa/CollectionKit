//
//  File.swift
//  
//
//  Created by Paul on 22/05/2023.
//

import Foundation
import Combine

extension URLSession {

    enum SessionError: Error {
        case statusCode(HTTPURLResponse)
    }

    func dataTaskPublisher<T: Decodable>(for url: URL) -> AnyPublisher<T, Error>{

        return self.dataTaskPublisher(for: url)
            .subscribe(on: DispatchQueue.global(qos: .background), options: nil)
            .tryMap { data, response -> Data in

                if let response = response as? HTTPURLResponse,(200..<300).contains(response.statusCode) == false {
                    throw SessionError.statusCode(response)
                }
                return data
            }.decode(type: T.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}

