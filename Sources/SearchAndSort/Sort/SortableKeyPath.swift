//
//  SortableKeyPath.swift
//  SearchAndSort
//
//  Created by MohammavDev on 1/10/25.
//


import Foundation



public struct SortableKeyPath<M : Sendable,K : Comparable> : SortableKeyPathProtocol, Sendable{
    
    public typealias Model = M
    
    public typealias Key = K
    
    
    
    
    public let key : KeyPath<Model, Key >
    
   
    
    init(_ key: KeyPath<Model,Key> ) {
        self.key = key
    }
}

//public struct SortableTitledKeyPath<M : Sendable,K : Comparable> : SortableKeyPathProtocol, Sendable{
//    
//    public typealias Model = M
//    
//    public typealias Key = K
//    
//    
//    var title : String
//    
//    public let key : KeyPath<Model, Key >
//}
public extension SortableKeyPath {
    func sort(_ model : [M] , order : SortOrder) async-> [M] {
        return await AnySorter(self, order: order).sorted(model)
    }
}
//public extension SortableTitledKeyPath {
//    func sort(_ model : [M] , order : SortOrder) async-> [M] {
//        return await AnySorter(self, order: order).sorted(model)
//    }
//}
