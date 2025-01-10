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


