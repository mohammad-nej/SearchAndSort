//
//  AnyKey.swift
//  SearchAndSort
//
//  Created by MohammavDev on 1/12/25.
//

import Foundation

public struct AnyKey<Root : Sendable> : Sendable , Sortable , Searchable {
        
 
    private let stringProducer :  @Sendable (Root) -> [String]
    
    private let sorterProducer : @Sendable ([Root], SortOrder) async-> [Root]
    
    private let searchProducer : @Sendable ([Root], String, SearchStrategy) async -> [Root]?
    
    
    
    
    
    public let partialKey : PartialKeyPath<Root>
   
    public func stringify(_ model : Root ) -> [String] {
        
        stringProducer(model)
    }
    public func search(in models : [Root] , for query : String , strategy: SearchStrategy = .contains) async -> [Root]? {
        await searchProducer(models , query, strategy)
    }
    public func sort(_ models : [Root] , order : SortOrder) async-> [Root] {
        await sorterProducer(models, order)
    }
    
}
public extension AnyKey {
    init<Key : CustomStringConvertible>(_ key : KeyPath<Root,Key>) where Key : Comparable  {
    
        
        let stringer = StringConvertableStringifier<Key>()
        self.stringProducer = { model in
            return stringer.stringify(model[keyPath: key])
        }

        sorterProducer = { models , order in
            let sortKey = SortableKeyPath(key)
            return await sortKey.sort(models , order: order)
        }
        searchProducer = { models , query,strategy in
            let key = SearchableKeyPath( key , stringifier: stringer)

            return await key.search(in: models, for: query,strategy: strategy)

        }
        partialKey = key as PartialKeyPath<Root>

    }
    init<Key : CustomStringConvertible, Stringer : Stringifier>(_ key : KeyPath<Root,Key>, stringer : Stringer) where Key : Comparable ,Stringer.Model == Key  {
    
        
        
        self.stringProducer = { model in
            return stringer.stringify(model[keyPath: key])
        }

        sorterProducer = { models , order in
            let sortKey = SortableKeyPath(key)
            return await sortKey.sort(models , order: order)
        }
        searchProducer = { models , query,strategy in
            let key = SearchableKeyPath( key , stringifier: stringer)

            return await key.search(in: models, for: query,strategy: strategy)

        }
        partialKey = key as PartialKeyPath<Root>
    }

}

public extension AnyKey {
    init<SearchKey : Comparable , Searchable : SearchableKeyProtocol>(_ key : Searchable) where Searchable.Item == Root , Searchable.Key == SearchKey , Searchable.Stringer.Model == SearchKey{
        
        let stringer = key.stringer
        self.stringProducer = { model in
            return stringer.stringify(model[keyPath: key.key])
        }
        
        sorterProducer = { models , order in
            let sortKey = SortableKeyPath(key.key)
            return await sortKey.sort(models , order: order)
        }
        searchProducer = { models , query,strategy in
            let key = key
            
            return await key.search(in: models, for: query,strategy: strategy)
            
        }
        partialKey = key.key as PartialKeyPath<Root>
    }
}


public extension AnyKey {
    init<SortKey : Comparable,Stringer : Stringifier , Sortable : SortableKeyPathProtocol>(_ key : Sortable , stringer : Stringer ) where SortKey == Stringer.Model , Sortable.Key == SortKey , Sortable.Model == Root {
        
        self.stringProducer = { model in
            return stringer.stringify(model[keyPath: key.key])
        }
        
        sorterProducer = { models , order in
            let sortKey = SortableKeyPath(key.key)
            return await sortKey.sort(models , order: order)
        }
        searchProducer = { models , query,strategy in
            let key = SearchableKeyPath( key , stringifier: stringer)
            
            return await key.search(in: models, for: query,strategy: strategy)
            
        }
        partialKey = key.key as PartialKeyPath<Root>
        
        
        let searchableKey = SearchableKeyPath( key,stringifier: stringer)
        
    }
}

///Initilize from SortableKeyPath
public extension AnyKey  {
    init<SortKey : Comparable, Sortable : SortableKeyPathProtocol>(_ key : Sortable) where SortKey: CustomStringConvertible , Sortable.Model == Root , Sortable.Key == SortKey {
        let stringer = StringConvertableStringifier<SortKey>()
        self.stringProducer = { model in
            return stringer.stringify(model[keyPath: key.key])
        }
        
        sorterProducer = { models , order in
            let sortKey = SortableKeyPath(key.key)
            return await sortKey.sort(models , order: order)
        }
        searchProducer = { models , query,strategy in
            let key = SearchableKeyPath( key , stringifier: stringer)
            
            return await key.search(in: models, for: query,strategy: strategy)
            
        }
        partialKey = key.key as PartialKeyPath<Root>
        
        
        let searchableKey = SearchableKeyPath( key,stringifier: stringer)
      
    }

}

public extension AnyKey {
    ///Initiates a key from a TitledKey
    init <Key, Stringer : Stringifier> (_ key : TitledKey<Root,Key,Stringer>) where Key : Comparable , Stringer.Model == Key {
        let stringer = key.stringer
        self.stringProducer = { model in
            return stringer.stringify(model[keyPath: key.key])
        }
        
        sorterProducer = { models , order in
            let sortKey = SortableKeyPath(key.key)
            return await sortKey.sort(models , order: order)
        }
        
        searchProducer = { models , query,strategy in
            //let key = SearchableKeyPath( key , stringifier: stringer)
            
            return await key.search(in: models, for: query,strategy: strategy)
            
        }
        partialKey = key.key as PartialKeyPath<Root>
        
        
        let searchableKey = SearchableKeyPath( key.key,stringifier: stringer)
    }
}


