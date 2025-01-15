//
//  SortableKeyPathProtocol.swift
//  SearchAndSort
//
//  Created by MohammavDev on 1/10/25.
//
import Foundation
public protocol  SortableKeyPathProtocol : ValuePresentable,Sortable, Sendable , Identifiable,Equatable{
    
    associatedtype Key : Comparable
    var id : UUID { get}
    var key : KeyPath<Model, Key> { get }
    
}
public extension SortableKeyPathProtocol{
    func value(for model : Model) -> Key {
        model[keyPath: key]
    }
    func sort(_ models : [Model] , order : SortOrder) async -> [Model] {
    
        return await Task.detached(priority: .userInitiated) {
            models.sorted { first, second in
                let value1 = first[keyPath: self.key]
                let value2 = second[keyPath: self.key]
                
                if order == .ascending {
                    return value1 < value2
                }else {
                    return value1 > value2
                }
            }
        }.value
        
    }
}
