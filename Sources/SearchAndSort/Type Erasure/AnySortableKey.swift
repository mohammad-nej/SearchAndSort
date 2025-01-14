//
//  AnySortableKeyPath.swift
//  SearchAndSort
//
//  Created by MohammavDev on 1/10/25.
//


import Foundation


///A type-erasure to store all kinds of SortableKeyPath, TitledKey in a single array (as long as they have the same Model type).
public struct AnySortableKey<Model : Sendable> : Sendable{
    
    typealias Value = Comparable
    private let closure : @Sendable ([Model],SortOrder) async -> [Model]
    
    public let order : SortOrder
    
    
    
    public init<T:Comparable, Sortable : SortableKeyPathProtocol>(_ item : Sortable) where Sortable.Key == T , Sortable.Model == Model{
        
        closure = { models , order in
            await item.sort(models, order: order)
        }
        order = item.order
    }
    
    public func sorted(_ models : [Model] , order : SortOrder? = nil) async -> [Model] {
        let sortOrder = order == nil ? self.order : order
        return await closure(models, sortOrder!)
         
    }
    
}

public extension AnySortableKey {
    init<Key:Comparable , Stringer>(_ item : TitledKey<Model, Key, Stringer>, order : SortOrder){
        
        
        
        self.closure = { models, order in

            await item.sort(models, order: order)
        }
        self.order = order
    }
    init<Key: Comparable>(_ key : KeyPath<Model , Key>, order : SortOrder){
        self.order = order
        let key = SortableKeyPath(key, order: order)
        self.closure = { models, order in
            await key.sort(models, order: order)
        }

    }
}
