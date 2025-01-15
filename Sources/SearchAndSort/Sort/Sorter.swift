//
//  Untitled.swift
//  SearchAndSort
//
//  Created by MohammavDev on 1/11/25.
//


///a struct to store all Sortable keys and your models in one place.
public struct Sorter<Model : Sendable> : Sendable {
    
    
    public let models : [Model]
    public let keys : [AnySortableTitledKey<Model>]
    
    
    public func sort(by key : AnySortableTitledKey<Model> , order : SortOrder) async-> [Model] {
        
        
        return await key.sort(models, order: order)
    }
    
}
