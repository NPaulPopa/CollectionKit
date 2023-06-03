//
//  File.swift
//  
//
//  Created by Paul on 22/05/2023.
//

import Foundation

public class FileManagerDataStore: DataStoreProtocol {
    
    public func getItemsArray<Item: Codable>() -> [Item]? {
        
        var itemsArray: [Item] = []
        
        fetchItems { (result: Result<[Item],Error>) in
            switch result {
                
            case .success(let items):
                itemsArray = items
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        return itemsArray
    }
    
    public func getSingleItem<Item>() -> Item? {
            fatalError()
    }
            
    // MARK: - Properties
    
    enum DiskError: Error {
        case invalidFileName
        case corruptData
        case encodingError
        case decodingError
    }
    
    private let fileName = String(describing: FileManagerDataStore.self).appending(".json")
        
    // MARK: - Initializer
    
    public init() {
        
    }

    //MARK: - Get Items
    
    /// Loads the Lists from disk
     ///  - To be used when first loading the view to retreive saved lists from FileManager
    public func fetchItems<Item: Codable>(completion: @escaping (Result<[Item], Error>) -> Void) {
        
        DispatchQueue.main.async { [weak self] in
            
            guard let self = self else { return }

            do {
                let fileURL = try self.getFileURL()
                
                guard let fileOnDisk = try? FileHandle(forReadingFrom: fileURL) else {
                    DispatchQueue.main.async {  completion(.failure(DiskError.invalidFileName)) }
                    return
                }
                
                let lists = try JSONDecoder().decode([Item].self, from: fileOnDisk.availableData)
                
                DispatchQueue.main.async { completion(.success(lists)) }
                
            } catch {
                DispatchQueue.main.async { completion(.failure(error)) }
            }
        }
    }

    //MARK: - Get Single Item //TODO: - Make it throwing
    
    public func fetchSingleItem<Item: Codable>(completion: @escaping (Result<Item, Error>) -> Void) {
        
        guard let jsonData = try? Data(contentsOf: getFileURL()) else {
            completion(.failure(DiskError.corruptData))
            return
        }
        
        let decoder = JSONDecoder()
        guard let singleItem = try? decoder.decode(Item.self, from: jsonData) else { completion(.failure(DiskError.decodingError))
            return
        }
        
        completion(.success(singleItem))
    }

    //MARK: Save Items
    
    public func saveItems<Item: Codable>(_ items: [Item], completion: @escaping (Result<Bool, Error>) -> Void) {
        
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let self = self else { return }
            
            guard let data = try? JSONEncoder().encode(items) else {
                completion(.failure(DiskError.encodingError))
                return
            }
            
            do {
                let fileToBeSavedURL = try self.getFileURL()
                try data.write(to: fileToBeSavedURL)
                
                DispatchQueue.main.async { completion(.success(true)) }
                
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
    
    //MARK: - Save Single Item
    
    public func saveSingleItem<Item: Codable>(_ item: Item) {
        
        let encoder = JSONEncoder()
        let jsonData = try! encoder.encode(item)
                
        do { try jsonData.write(to: getFileURL())
            
        } catch let error {
            print("Error saving grocery list to disk; \(error)")
        }
    }
    
    //MARK: - Private Methods

    private func getFileURL() throws -> URL {
                
       let url = try FileManager.default.url(
            for: .documentDirectory,
            in: .userDomainMask,
            appropriateFor: nil, create: false).appendingPathComponent(fileName)
            return url
    }
}
