//
//  AnyTitledKey.swift
//  SearchAndSort
//
//  Created by MohammavDev on 1/15/25.
//

public struct AnySearchableTitledKey<Model : Sendable> : Sendable , Searchable {

    let title : String
    public let key : PartialKeyPath<Model>
    
    
    private let stringProducer :  @Sendable (Model) -> [String]
    private let searcherFunc : @Sendable ([Model],String,SearchStrategy) async -> [Model]?
//    private let sortFunc : @Sendable ([Model],SortOrder) async -> [Model]
    
    public init<Key,Stringer : Stringifier>(title: String, key: KeyPath<Model,Key> , stringer : Stringer) where Stringer.Model == Key {
        self.title = title
        self.key = key
        
        let searchable = SearchableKeyPath(key, stringifier: stringer)
        self.searcherFunc = { array,query,strategy in
            
            
            return await searchable.search(in: array, for: query, strategy: strategy)
        }
        self.stringProducer = { model in
            searchable.stringify(model)
        }
//        self.sortFunc = { array,order in
//            let sortableKey = SortableKeyPath(key)
//            return await sortableKey.sort(array, order: order)
//        }
       
    }
    public func stringify(_ model: Model) -> [String] {
        return stringProducer(model)
    }
    public func search(in array : [Model] , for query : String , strategy : SearchStrategy) async-> [Model]? {
        
        return await searcherFunc(array,query,strategy)
    }
//    public func sort(_ models : [Model],order : SortOrder) async -> [Model] {
//        
//        return await sortFunc(models,order)
//    }
}



public extension AnySearchableTitledKey{
    init(_ key : AnySearchableKey<Model> , title : String = "") {
        self.key = key.partialKey
        self.title = title
        self.searcherFunc = key.search(in:for:strategy:)
//        self.sortFunc = key.sort(_:order:)
        
        self.stringProducer = {model in
            key.stringify(model)
        }
        
    }
}

//public extension AnyTitledKey {
//    init<Key : CustomStringConvertible>
//    
//    
//}
