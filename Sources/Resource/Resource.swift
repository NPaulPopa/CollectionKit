//
//  File.swift
//  
//
//  Created by Paul on 21/05/2023.
//

import Foundation

public protocol Resource: Hashable, Identifiable where Self.ID == String
{
    var id: String { get }
    var isSelected: Bool { get set }
}

public protocol CodableResource: Codable & Resource { }
