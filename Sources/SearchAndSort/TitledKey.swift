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
    
    public func stringify(_ item : Model) -> [String] {
        return stringer.stringify(item[keyPath: key])
    }
}


extension TitledKey where Key : Comparable {
    
    init<S : SortableKeyPathProtocol>(title: String , key : S , stringifier : Stringified ) where S.Key == Key , S.Model == Model , Stringified.Model == S.Key  {
        self.title = title
        self.key = key.key
        self.stringer = stringifier
    }
}
