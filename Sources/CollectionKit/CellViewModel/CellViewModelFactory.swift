//
//  File.swift
//  
//
//  Created by Paul on 22/05/2023.
//

import Foundation

public class CellViewModelFactory<ItemModel, VM: CellViewModel> {
    
    public init() { }
    
    let cellViewModel = { (item: ItemModel) -> VM in
                
        let genericCellVM = VM(resource: item)
        return genericCellVM
    }
}
