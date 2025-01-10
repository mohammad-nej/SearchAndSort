//
//  SortableKeyPathProtocol.swift
//  SearchAndSort
//
//  Created by MohammavDev on 1/10/25.
//

public protocol  SortableKeyPathProtocol : Sendable{
    associatedtype Model : Sendable
    associatedtype Key : Comparable
    
    var key : KeyPath<Model, Key> { get }
}
extension SortableKeyPathProtocol{
    func value(for model : Model) -> Key {
        model[keyPath: key]
    }
}
