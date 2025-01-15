//
//  TitledKey.swift
//  SearchAndSort
//
//  Created by MohammavDev on 1/8/25.
//


import Foundation
import Foundation


///A type to store your Keys and a title string attached to it. You can use it to Search over your models. You can also use it to Sort if your Key confroms to Comparable
public struct TitledKey<Model : Sendable ,Key , Stringified : Stringifier> : SearchableKeyProtocol , Sendable , Identifiable,Equatable where Stringified.Model == Key {
    
    public let id : UUID = UUID()
    public static func  == (lhs: TitledKey<Model,Key,Stringified>, rhs: TitledKey<Model,Key,Stringified>) -> Bool {
        return lhs.id == rhs.id
    }
    
    
    public typealias Item = Model
    
    public typealias Key = Key
    
    public typealias Stringer = Stringified
    
    public typealias Model = Model
        
    
    
    public var stringer: Stringified
    public var title: String
    public var key : KeyPath<Model, Key>
    
    public init( title: String, key: KeyPath<Model, Key>,stringer: Stringified) {
        self.stringer = stringer
        self.title = title
        self.key = key
    }

}


public extension TitledKey where Key : Comparable {
    
    init<S : SortableKeyPathProtocol>(title: String , key : S , stringifier : Stringified ) where S.Key == Key , S.Model == Model , Stringified.Model == S.Key  {
        self.title = title
        self.key = key.key
        self.stringer = stringifier
        
    }
  
}
public extension TitledKey where Key : CustomStringConvertible, Key : Comparable , Stringified == StringConvertableStringifier<Key> {
    
    
    init<S : SortableKeyPathProtocol>(title: String , key : S) where S.Key == Key , S.Key : CustomStringConvertible , S.Model == Model , Stringified.Model == S.Key{
        self.title = title
        self.key = key.key
        self.stringer = StringConvertableStringifier<Key>()
        
    }
}
extension TitledKey : Sortable where Key : Comparable {
    
    public func sort(_ items : [Model] , order : SortOrder) async -> [Model] {
        let sortable = SortableKeyPath(self.key)
        
        return await sortable.sort(items, order: order)
    }
}
public extension TitledKey{
    func search(in models : [Model] , for query : String, strategy: SearchStrategy = .contains) async-> [Model]? {
        let searcher = BackgroundSearcher(models:models,keys: [.init(self)],strategy: strategy)
        return await searcher.search(query)
    }
}
public extension TitledKey where Key : CustomStringConvertible, Stringified == StringConvertableStringifier<Key> {
    init (title: String , key : KeyPath<Model, Key> ){
        self.title = title
        self.key = key
        self.stringer = StringConvertableStringifier<Key>()
    }
    
}




