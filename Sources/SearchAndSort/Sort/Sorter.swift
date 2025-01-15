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
    
    public init(models: [Model], keys: [AnySortableTitledKey<Model>]) {
        self.models = models
        self.keys = keys
    }
    
    public init (models : [Model] , keys : [AnySortableKey<Model>]) {
        self.models = models
        self.keys = keys.map{AnySortableTitledKey($0, title: "Not Provided")}
    }
    
    public init(models : [Model], keys : [AnyTitledKey<Model>]){
        self.models = models
        self.keys = keys.map{AnySortableTitledKey($0)}
    }
    
    public init(models : [Model] , keys : [AnyKey<Model>]){
        self.models = models
        self.keys = keys.map{AnySortableTitledKey(AnySortableKey($0), title: "Not Provided")}
    }
    
    public func sort(by key : AnySortableTitledKey<Model> , order : SortOrder) async-> [Model] {
        
        
        return await key.sort(models, order: order)
    }
    
}
