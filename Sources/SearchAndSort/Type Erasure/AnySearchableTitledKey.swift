//
//  AnyTitledKey.swift
//  SearchAndSort
//
//  Created by MohammavDev on 1/15/25.
//
import Foundation
public struct AnySearchableTitledKey<Model : Sendable> : Sendable , Searchable,Identifiable ,Equatable {

    public let id : UUID = UUID()
    public static func  == (lhs: AnySearchableTitledKey<Model>, rhs: AnySearchableTitledKey<Model>) -> Bool {
        return lhs.id == rhs.id
    }
    
    public let title : String
    public let key : PartialKeyPath<Model>
    
    
    private let stringProducer :  @Sendable (Model) -> [String]
    private let searcherFunc : @Sendable ([Model],String,SearchStrategy) async -> [Model]?
//    private let sortFunc : @Sendable ([Model],SortOrder) async -> [Model]
    
    public init<Key,Stringer : Stringifier>( _ key: KeyPath<Model,Key>,title: String, stringer : Stringer) where Stringer.Model == Key {
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
    
    
    init<Key : CustomStringConvertible>( _ key: KeyPath<Model,Key>,title: String) {
        self.title = title
        self.key = key
        
        let stringer = StringConvertableStringifier<Key>()
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
    
    
    init(_ key : AnySearchableKey<Model> , title : String = "") {
        self.key = key.partialKey
        self.title = title
        self.searcherFunc = key.search(in:for:strategy:)
//        self.sortFunc = key.sort(_:order:)
        
        self.stringProducer = {model in
            key.stringify(model)
        }
        
    }
    init(_ key : AnyKey<Model>, title : String){
        self.title = title
        self.key = key.partialKey
        self.searcherFunc = { model , query ,strategy in
            await key.search(in: model, for: query, strategy: strategy)
        }
        self.stringProducer = {model in
            key.stringify(model)
        }
    }
}

public extension AnySearchableTitledKey  {
    
    init<Key,Stringered:Stringifier>(_ key : TitledKey<Model,Key,Stringered>) where Stringered.Model == Key{
        self.key = key.key
        self.searcherFunc = { model , query ,strategy in
            await key.search(in: model, for: query, strategy: strategy)
        }
        self.stringProducer = {model in
             key.stringify(model)
        }
        self.title = key.title
    }
    
}

extension AnySearchableTitledKey : Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

//public extension AnyTitledKey {
//    init<Key : CustomStringConvertible>
//    
//    
//}
