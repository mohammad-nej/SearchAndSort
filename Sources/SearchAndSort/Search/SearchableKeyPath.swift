//
//  SearchableKey.swift
//  SearchAndSort
//
//  Created by MohammavDev on 1/11/25.
//
import Foundation

public struct SearchableKeyPath<Model : Sendable ,Key , Stringified : Stringifier> : SearchableKeyProtocol,Sendable where Stringified.Model == Key  {
    public var stringer: Stringified
    
    public let id = UUID()
    public typealias Item = Model
    
    public typealias Key = Key
    
    public typealias Stringer = Stringified
    
    public var key: KeyPath<Item, Key>
    
    public init<T : SortableKeyPathProtocol>(_ key : T , stringifier : Stringified) where T.Model == Model, T.Key == Key{
        self.key = key.key
        self.stringer = stringifier
    }
    public init(_ key: KeyPath<Item, Key> , stringifier : Stringified ) {
        self.key = key
        self.stringer = stringifier
    }
}

extension SearchableKeyPath  {
    public init(_ key : KeyPath<Model, Key>) where Key : CustomStringConvertible, Stringified == StringConvertableStringifier<Key> {
        self.key = key
        self.stringer = StringConvertableStringifier<Key>()
        
    }
}
extension SearchableKeyPath : Sortable where Key : Comparable  {
    public func sort(_ models: [Item], order: SortOrder) async -> [Item] {
        return await  SortableKeyPath(key).sort(models, order: order)
    }
    
    
}
