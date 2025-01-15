//
//  AnyTitledKey.swift
//  SearchAndSort
//
//  Created by MohammavDev on 1/15/25.
//
import Foundation


///Type erasre that let you store TitledKeys with same Model type in an array. Your Key type should confrom to Comparable
public struct AnyTitledKey<Model : Sendable> : Searchable , Sortable ,Identifiable   {
    public var id: UUID = UUID()
    public var title: String
    
    private let searchFunc : @Sendable ( [Model] , String , SearchStrategy ) async -> [Model]?
    private let sortFunc : @Sendable ([Model] , SortOrder ) async-> [Model]
    private let stringifyFunc : @Sendable ( Model ) -> [String]
    
    public func stringify(_ model: Model) -> [String] {
        return stringifyFunc(model)
    }
    
    public init<Key: Comparable,Stringered:Stringifier>(_ key : TitledKey<Model,Key,Stringered>) {
        
        self.title = key.title
        
        self.searchFunc = { models , query , strategy in
            await key.search(in: models, for: query, strategy: strategy)
        }
        self.sortFunc = { models , order in
            await key.sort(models, order: order)
        }
        self.stringifyFunc = { model in
            key.stringify(model)
        }
    }
    
    public func search(in models: [Model], for query: String, strategy: SearchStrategy) async -> [Model]? {
        return nil
    }
    public func sort(_ models: [Model], order: SortOrder) async -> [Model] {
        return []
    }
    
}
extension AnyTitledKey : Equatable {
    public static func == (lhs: AnyTitledKey<Model>, rhs: AnyTitledKey<Model>) -> Bool {
        return lhs.id == rhs.id
    }
}
extension AnyTitledKey : Hashable {
   public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
}
public extension AnyTitledKey {
    
    init<Key:Comparable,Stringered:Stringifier>(_ keyPath : KeyPath<Model,Key> , title : String , stringifier : Stringered) where Stringered.Model == Key {
        
        let TitledKey = TitledKey(title: title, key: keyPath, stringer: stringifier)
        self.searchFunc = { model , query , strategy in
            
            await TitledKey.search(in: model, for: query, strategy: strategy)
        }
        self.sortFunc = { model , order in
            await TitledKey.sort( model, order: order)
        }
        
        self.stringifyFunc = { model in
            TitledKey.stringify(model)
        }
        
        self.title = title
    }
    init<Key:Comparable>(_ keyPath : KeyPath<Model,Key>,title:String) where Key:CustomStringConvertible {
        let stringifier = StringConvertableStringifier<Key>()
        let TitledKey = TitledKey(title: title, key: keyPath, stringer: stringifier)
        self.searchFunc = { model , query , strategy in
            
            await TitledKey.search(in: model, for: query, strategy: strategy)
        }
        self.sortFunc = { model , order in
            await TitledKey.sort( model, order: order)
        }
        
        self.stringifyFunc = { model in
            TitledKey.stringify(model)
        }
        self.title = title
    }
    init(_ key : AnyKey<Model>, title : String){
        self.title = title
        self.searchFunc = { model , query , strategy in
            await key.search(in: model, for: query, strategy: strategy)
        }
        self.sortFunc = { model , order in
            await key.sort( model, order: order)
        }
        self.stringifyFunc = { model in
            key.stringify(model)
        }
    }
    
}
