//
//  AnyTitledKey.swift
//  SearchAndSort
//
//  Created by MohammavDev on 1/15/25.
//

public struct AnyTitledKey<Model : Sendable>  {

    let title : String
    public let key : PartialKeyPath<Model>
    
    private let searcherFunc : @Sendable ([Model],String,SearchStrategy) async -> [Model]?
    private let sortFunc : @Sendable ([Model],SortOrder) async -> [Model]
    
    public init<Key : Comparable,Stringer : Stringifier>(title: String, key: KeyPath<Model,Key> , stringer : Stringer) where Stringer.Model == Key {
        self.title = title
        self.key = key
        
        self.searcherFunc = { array,query,strategy in
            
            let searchable = SearchableKeyPath(key, stringifier: stringer)
            return await searchable.search(in: array, for: query, strategy: strategy)
        }
        self.sortFunc = { array,order in
            let sortableKey = SortableKeyPath(key,order: order)
            return await sortableKey.sort(array)
        }
       
    }
    
    public func search(in array : [Model] , for query : String , strategy : SearchStrategy) async-> [Model]? {
        
        return await searcherFunc(array,query,strategy)
    }
    public func sort(_ models : [Model],order : SortOrder) async -> [Model] {
        
        return await sortFunc(models,order)
    }
}

public extension AnyTitledKey{
     init(_ key : AnyKey<Model> , title : String = "") {
        self.key = key.partialKey
        self.title = title
        self.searcherFunc = key.search(_:query:strategy:)
        self.sortFunc = key.sort(_:order:)
        
        
        
    }
}

//public extension AnyTitledKey {
//    init<Key : CustomStringConvertible>
//    
//    
//}
