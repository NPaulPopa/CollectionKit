//
//  File.swift
//  
//
//  Created by Paul on 22/05/2023.
//

import Foundation
import Combine

public protocol DataStoreProtocol {

    func fetchItems<Item: Codable>(completion: @escaping (Result<[Item],Error>) -> Void)
    func fetchSingleItem<Item: Codable>(completion: @escaping(Result<Item,Error>) -> Void)
    
    func load<Item: Codable>(completion: @escaping (Result<[Item],Error>) -> Void)

    func saveItems<Item: Codable>(_ items: [Item], completion: @escaping (Result<Bool, Error>) -> Void)
     
    func saveSingleItem<Item: Codable>(_ item: Item)

    func getItemsArray<Item: Codable>() -> [Item]?
    func getSingleItem<Item>() -> Item?
    
}

extension DataStoreProtocol {
    
    public func load<Item: Codable>(completion: @escaping (Result<[Item],Error>) -> Void) { fatalError() }
    
  //  public func getItemsArray<Item>() -> [Item]? { fatalError() }
  //  public func getSingleItem<Item>() -> Item? { fatalError() }
    
  //  public func saveItems<Item: Codable>(_ items: [Item], completion: @escaping (Result<Bool, Error>) -> Void) { fatalError() }
    
   // public func saveSingleItem<Item: Codable>(_ item: Item) { fatalError() }
}

/* Methods that are used everywhre
 
 1.  func getItemsArray<Item>() -> [Item]?

 */
