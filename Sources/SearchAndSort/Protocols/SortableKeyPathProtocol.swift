//
//  SortableKeyPathProtocol.swift
//  SearchAndSort
//
//  Created by MohammavDev on 1/10/25.
//

public protocol  SortableKeyPathProtocol : ValuePresentable, Sendable{
    //associatedtype Model : Sendable
    associatedtype Key : Comparable
    
    var key : KeyPath<Model, Key> { get }
    
    var order : SortOrder { get }
    
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
    func sort(_ models : [Model]) async -> [Model] {
        await sort(models, order: order)
    }
}
