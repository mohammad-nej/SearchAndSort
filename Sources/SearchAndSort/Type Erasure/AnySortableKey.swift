//
//  AnySortableKeyPath.swift
//  SearchAndSort
//
//  Created by MohammavDev on 1/10/25.
//


import Foundation


///A type-erasure to store all kinds of SortableKeyPath, TitledKey in a single array (as long as they have the same Model type).
public struct AnySortableKey<Model : Sendable> : Sendable{
    
    typealias Value = Comparable
    private let closure : @Sendable ([Model],SortOrder?) async -> [Model]
    
    let order : SortOrder
    
    
    
    
    init<T:Comparable>(_ item : SortableKeyPath<Model,T> , order : SortOrder ) {
        self.order = order
        closure = { models , order in
            models.sorted { first, second in
                let value1 = item.value(for: first)
                let value2 = item.value(for: second)
                
                if order == .ascending{
                    return value1 < value2
                }else{
                    return value1 > value2
                }
            }
        }
        
    }
    
    func sorted(_ models : [Model] , order : SortOrder? = nil) async -> [Model] {
        let sortOrder = order == nil ? self.order : order
        return await Task.detached {
            return await closure(models, sortOrder)
         }.value
    }
    
}

public extension AnySortableKey {
    init<Key:Comparable , Stringer>(_ item : TitledKey<Model, Key, Stringer>, order : SortOrder){
        
        self.order = order
        let key = SortableKeyPath(item.key)
        self.closure = { models, order in
            models.sorted { first, second in
                let value1 = key.value(for: first)
                let value2 = key.value(for: second)
                if order == .ascending{
                    return value1 < value2
                }else{
                    return value1 > value2
                }
            }

        }
    }
}
