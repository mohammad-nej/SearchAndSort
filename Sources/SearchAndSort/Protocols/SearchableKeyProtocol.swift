//
//  SearchableKey.swift
//  SearchAndSort
//
//  Created by MohammavDev on 1/8/25.
//


import Foundation
import Foundation

public protocol SearchableKeyProtocol : ValuePresentable, Searchable ,Sendable
,Identifiable,Equatable
where  Stringer.Model == Key, Value == Key   {
    associatedtype Item : Sendable
    associatedtype Key
    associatedtype Stringer : Stringifier
    
    var id : UUID { get }
    
    var key : KeyPath<Item , Key>  { get set}
    var stringer : Stringer { get}
    func search(in models : [Item] , for query : String , strategy : SearchStrategy) async -> [Item]?
}
public extension SearchableKeyProtocol {
    func value(for model: Item) -> Key {
        return model[keyPath: key]
    }
    
}
public extension SearchableKeyProtocol {
    func stringify(_ model: Item) -> [String] {
        return stringer.stringify(model[keyPath:key])
    }
}
public extension SearchableKeyProtocol {
    func search(in models : [Item] , for query : String , strategy : SearchStrategy)async -> [Item]? {
        let searcher = BackgroundSearcher(models:models, keys : [AnySearchableKey(self)])
        return await searcher.search(query, strategy:strategy)
                                          
    }
}
extension SearchableKeyProtocol {
    func equals(_ lhs: Self, _ rhs: Self) -> Bool {
        return lhs.id == rhs.id
    }
}
