//
//  Untitled.swift
//  SearchAndSort
//
//  Created by MohammavDev on 1/11/25.
//


///a struct to store all Sortable keys and your models in one place.
public struct Sorter<Model : Sendable> : Sendable {
    
    
    public let models : [Model]
    public let keys : [AnySortableKey<Model>]
    
    
    public func sort(by key : AnySortableKey<Model> , order : SortOrder? = nil) async-> [Model] {
        
        let order = order == nil ? key.order : order!
        return await key.sorted(models, order: order)
    }
    
}
