//
//  SearchableKey.swift
//  SearchAndSort
//
//  Created by MohammavDev on 1/11/25.
//
import Foundation

public struct SearchableKeyPath<Model : Sendable ,Key , Stringified : Stringifier> : SearchableKeyProtocol,Sendable where Stringified.Model == Key  {
    public var stringer: Stringified
    
    
    public typealias Item = Model
    
    public typealias Key = Key
    
    public typealias Stringer = Stringified
    
    public var key: KeyPath<Item, Key>
    
    init<T : SortableKeyPathProtocol>(key : T , stringifier : Stringified) where T.Model == Model, T.Key == Key{
        self.key = key.key
        self.stringer = stringifier
    }
    init(key: KeyPath<Item, Key> , stringifier : Stringified ) {
        self.key = key
        self.stringer = stringifier
    }
}
public extension SearchableKeyPath {
    
    func search(in models : [Model], for query : String, strategy : SearchStrategy = .contains) async -> [Model]? {
        let searcher = BackgroundSearcher(models:models,keys: [.init(self)], strategy: strategy)
        return await searcher.search(query)
    }
}
public extension SearchableKeyPath where Stringer.Model == Int {
    init (key : KeyPath<Item , Int> , stringifier : Stringified = .default ) {
        self.key = key
        self.stringer = stringifier
    }
}
public extension SearchableKeyPath where Stringer.Model == String {
    init (key : KeyPath<Item , String> , stringifier : Stringified = .default ) {
        self.key = key
        self.stringer = stringifier
    }
}
public extension SearchableKeyPath where Stringer.Model == Double {
    init (key : KeyPath<Item , Double> , stringifier : Stringified = .default ) {
        self.key = key
        self.stringer = stringifier
    }
}
public extension SearchableKeyPath where Stringer.Model == Bool {
    init (key : KeyPath<Item , Bool> , stringifier : Stringified = .default ) {
        self.key = key
        self.stringer = stringifier
    }
}
public extension SearchableKeyPath where Stringer.Model == Date {
    init (key : KeyPath<Item , Date> , stringifier : Stringified = .default ) {
        self.key = key
        self.stringer = stringifier
    }
}
