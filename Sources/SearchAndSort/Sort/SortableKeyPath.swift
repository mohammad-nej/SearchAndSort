//
//  SortableKeyPath.swift
//  SearchAndSort
//
//  Created by MohammavDev on 1/10/25.
//


import Foundation


public struct SortableKeyPath<M : Sendable,K : Comparable> : SortableKeyPathProtocol, Sendable{
    public typealias Models = Model
    
    
        
    
    
    
    public typealias Model = M
    
    public typealias Key = K
    
    
    
    
    public let key : KeyPath<Model, Key >
    
   
    
    public init(_ key: KeyPath<Model,Key> ) {
        self.key = key
        
    }
}

