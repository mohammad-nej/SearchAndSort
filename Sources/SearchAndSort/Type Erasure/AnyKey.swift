//
//  AnyKey.swift
//  SearchAndSort
//
//  Created by MohammavDev on 1/12/25.
//

import Foundation

public struct AnyKey<Root : Sendable> : Sendable {
        
 
    private let stringProducer :  @Sendable (Root) -> [String]
    
    private let sorterProducer : @Sendable ([Root], SortOrder) async-> [Root]
    
    private let searchProducer : @Sendable ([Root], String, SearchStrategy) async -> [Root]?
    
    public let order : SortOrder
    
    public let partialKey : PartialKeyPath<Root>
    
    public let anySearchableKey : AnySearchableKey<Root>
    public let anySortableKey : AnySortableKey<Root>
    
    public init<T : SearchableKeyProtocol>(_ item : T , sortOrder : SortOrder) where T.Item == Root , T.Key : Comparable {
        self.stringProducer = { model in
            return item.stringify(model)
        }
        self.order = sortOrder
        sorterProducer = { models , order in
            let sortKey = SortableKeyPath(item.key)
            return await sortKey.sort(models , order: order)
        }
        searchProducer = { models , query , strategy in
            let key = SearchableKeyPath(key: item.key , stringifier: item.stringer)
            
            return await key.search(in: models, for: query,strategy: strategy)
            
        }
        partialKey = item.key as PartialKeyPath<Root>
        
        anySearchableKey = AnySearchableKey(item)
        let sortable = SortableKeyPath(item.key)
        anySortableKey = AnySortableKey(sortable, order: sortOrder)
        
    }
    
    public func stringify(_ model : Root ) -> [String] {
        
        stringProducer(model)
    }
    public func search(_ models : [Root] , query : String , strategy: SearchStrategy = .contains) async -> [Root]? {
        await searchProducer(models , query, strategy)
    }
    public func sort(_ models : [Root] , order : SortOrder) async-> [Root] {
        await sorterProducer(models, order)
    }
    
}
public extension AnyKey  {
    init<Stringer: Stringifier>(_ key : KeyPath<Root,String>,sortOrder : SortOrder ,stringer : Stringer = .default  ) where Stringer.Model == String   {

        

        self.stringProducer = { model in
            return stringer.stringify(model[keyPath: key])
        }
        
        sorterProducer = { models , order in
            let sortKey = SortableKeyPath(key)
            return await sortKey.sort(models , order: order)
        }
        searchProducer = { models , query,strategy in
            let key = SearchableKeyPath(key: key , stringifier: stringer)
            
            return await key.search(in: models, for: query,strategy: strategy)
            
        }
        partialKey = key as PartialKeyPath<Root>
        
        self.order = sortOrder
        let searchableKey = SearchableKeyPath(key: key)
        anySearchableKey = AnySearchableKey(searchableKey)
        let sortable = SortableKeyPath(key)
        anySortableKey = AnySortableKey(sortable, order: sortOrder)
    }
    init<Stringer: Stringifier>(_ key : KeyPath<Root,Int>,sortOrder : SortOrder ,stringer : Stringer = .default  ) where Stringer.Model == Int   {

        

        self.stringProducer = { model in
            return stringer.stringify(model[keyPath: key])
        }
        
        sorterProducer = { models , order in
            let sortKey = SortableKeyPath(key)
            return await sortKey.sort(models , order: order)
        }
        searchProducer = { models , query,strategy in
            let key = SearchableKeyPath(key: key , stringifier: stringer)
            
            return await key.search(in: models, for: query,strategy: strategy)
            
        }
        partialKey = key as PartialKeyPath<Root>
        
        self.order = sortOrder
        let searchableKey = SearchableKeyPath(key: key)
        anySearchableKey = AnySearchableKey(searchableKey)
        let sortable = SortableKeyPath(key)
        anySortableKey = AnySortableKey(sortable, order: sortOrder)
    }
    
    init<Stringer: Stringifier>(_ key : KeyPath<Root,Double>,sortOrder : SortOrder ,stringer : Stringer = .default  ) where Stringer.Model == Double   {
        

        self.stringProducer = { model in
            return stringer.stringify(model[keyPath: key])
        }
        
        sorterProducer = { models , order in
            let sortKey = SortableKeyPath(key)
            return await sortKey.sort(models , order: order)
        }
        searchProducer = { models , query, strategy in
            let key = SearchableKeyPath(key: key , stringifier: stringer)
            
            return await key.search(in: models, for: query,strategy: strategy)
            
        }
        partialKey = key as PartialKeyPath<Root>
        
        self.order = sortOrder
        let searchableKey = SearchableKeyPath(key: key)
        anySearchableKey = AnySearchableKey(searchableKey)
        let sortable = SortableKeyPath(key)
        anySortableKey = AnySortableKey(sortable, order: sortOrder)
    }
    init<Stringer: Stringifier>(_ key : KeyPath<Root,Date>,sortOrder : SortOrder ,stringer : Stringer = .default  ) where Stringer.Model == Date   {
        

        self.stringProducer = { model in
            return stringer.stringify(model[keyPath: key])
        }
        
        sorterProducer = { models , order in
            let sortKey = SortableKeyPath(key)
            return await sortKey.sort(models , order: order)
        }
        searchProducer = { models , query , strategy in
            let key = SearchableKeyPath(key: key , stringifier: stringer)
            
            return await key.search(in: models, for: query,strategy: strategy)
            
        }
        partialKey = key as PartialKeyPath<Root>
        
        self.order = sortOrder
        let searchableKey = SearchableKeyPath(key: key)
        anySearchableKey = AnySearchableKey(searchableKey)
        let sortable = SortableKeyPath(key)
        anySortableKey = AnySortableKey(sortable, order: sortOrder)
    }
    init<T : Comparable,Stringer: Stringifier>(_ key : KeyPath<Root , T>,sortOrder : SortOrder , stringer : Stringer ) where Stringer.Model == T {
        self.stringProducer = { model in
            return stringer.stringify(model[keyPath: key])
        }
        
        sorterProducer = { models , order in
            let sortKey = SortableKeyPath(key)
            return await sortKey.sort(models , order: order)
        }
        searchProducer = { models , query, strategy in
            let key = SearchableKeyPath(key: key , stringifier: stringer)
            
            return await key.search(in: models, for: query,strategy: strategy)
            
        }
        partialKey = key as PartialKeyPath<Root>

        self.order = sortOrder
        
        let searchableKey = SearchableKeyPath(key: key , stringifier: stringer)
        anySearchableKey = AnySearchableKey(searchableKey)
        let sortable = SortableKeyPath(key)
        anySortableKey = AnySortableKey(sortable, order: sortOrder)
    }

}
