//
//  AnySortableKeyPath.swift
//  SearchAndSort
//
//  Created by MohammavDev on 1/10/25.
//


import Foundation


///A type-erasure to store all kinds of SortableKeyPath, TitledKey in a single array (as long as they have the same Model type).
public struct AnySortableKey<Model : Sendable> : Sendable , Sortable,Identifiable,Equatable{
    
    public let id : UUID = UUID()
    public static func  == (lhs: AnySortableKey<Model>, rhs: AnySortableKey<Model>) -> Bool {
        return lhs.id == rhs.id
    }
    
    
    typealias Value = Comparable
    private let closure : @Sendable ([Model],SortOrder) async -> [Model]
    
    public init<T:Comparable, Sortable : SortableKeyPathProtocol>(_ item : Sortable) where Sortable.Key == T , Sortable.Model == Model{
        
        closure = { models , order in
            await item.sort(models, order: order)
        }
        
    }
    
    public func sort(_ models : [Model] , order : SortOrder) async -> [Model] {
        
        return await closure(models,order)
         
    }
    
}

public extension AnySortableKey {
    init<Key:Comparable , Stringer>(_ item : TitledKey<Model, Key, Stringer>){
        self.closure = { models, order in

            await item.sort(models, order: order)
        }
    }
    init<Key: Comparable>(_ key : KeyPath<Model , Key>){
        
        let key = SortableKeyPath(key)
        self.closure = { models, order in
            await key.sort(models, order: order)
        }

    }
     init(_ key : AnyKey<Model>){
        self.closure = { models, order in
            await key.sort(models, order: order)
        }
    }
}
extension AnySortableKey : Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
