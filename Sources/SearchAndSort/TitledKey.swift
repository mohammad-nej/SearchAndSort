//
//  TitledKey.swift
//  SearchAndSort
//
//  Created by MohammavDev on 1/8/25.
//


import Foundation
import Foundation

public struct TitledKey<Model : Sendable ,Key , Stringified : Stringifier> : SearchableKey , Sendable where Stringified.Model == Key {
    
    
    
    
    public typealias Item = Model
    
    public typealias Key = Key
    
    public typealias Stringer = Stringified
    
    public typealias Model = Model
        
    
    public var stringer: Stringified
    public var title: String
    public var key : KeyPath<Model, Key> 
    
    init( title: String, key: KeyPath<Model, Key>,stringer: Stringified) {
        self.stringer = stringer
        self.title = title
        self.key = key
    }
    
    public func stringify(_ item : Model) -> [String] {
        return stringer.stringify(item[keyPath: key])
    }
}


public extension TitledKey where Key : Comparable {
    
    init<S : SortableKeyPathProtocol>(title: String , key : S , stringifier : Stringified ) where S.Key == Key , S.Model == Model , Stringified.Model == S.Key  {
        self.title = title
        self.key = key.key
        self.stringer = stringifier
    }
}
public extension TitledKey where Key : Comparable {
    
    func sort(_ items : [Model] , order : SortOrder) async -> [Model] {
        let sortable = SortableKeyPath(self.key)
        return await AnySorter(sortable,order: order).sorted(items)
    }
}
public extension TitledKey {
    func search(in models : [Model] , for query : String) async-> [Model]? {
        let searcher = BackgroundSearcher(models:models,keys: [.init(self)])
        return await searcher.search(query)
    }
}
