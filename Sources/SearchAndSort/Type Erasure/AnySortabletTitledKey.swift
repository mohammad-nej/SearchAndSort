//
//  AnySortabletTitledKey.swift
//  SearchAndSort
//
//  Created by MohammavDev on 1/15/25.
//
import Foundation
public struct AnySortableTitledKey<Model: Sendable>:  Sortable,Identifiable,Equatable {
    
    private let sortFunc : @Sendable ([Model],SortOrder) async -> [Model]
    
    public let id : UUID = UUID()
    public static func  == (lhs: AnySortableTitledKey<Model>, rhs: AnySortableTitledKey<Model>) -> Bool {
        return lhs.id == rhs.id
    }
    
    public let title : String
    
    public init<Key : Comparable,Stringer:Stringifier>(_ key : TitledKey<Model,Key,Stringer>)where Stringer.Model == Key{
        self.title = key.title
        self.sortFunc = { models, order in
            return await key.sort(models, order: order)
        }
 
    }
    
 
    public func sort(_ models: [Model], order: SortOrder) async -> [Model] {
        return await sortFunc(models,order)
    }
    
    public typealias Models = Model
}
extension AnySortableTitledKey {
    
    public init<Key : Comparable>(_ keyPath : KeyPath<Model,Key>,title:String) {
        self.title = title
        let sortableKey = SortableKeyPath(keyPath)
        self.sortFunc = { models, order in
            return await  sortableKey.sort(models, order: order)
        }
    }
    public init<Key:Comparable>(_ key : SortableKeyPath<Model,Key> , title : String) {
        self.title = title
        self.sortFunc = { models, order in
            return await  key.sort(models, order: order)
        }
    }
}
