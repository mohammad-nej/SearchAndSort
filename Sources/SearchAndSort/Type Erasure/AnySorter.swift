//
//  AnySortableKeyPath.swift
//  SearchAndSort
//
//  Created by MohammavDev on 1/10/25.
//


import Foundation

public struct AnySorter<Model : Sendable> : Sendable{
    
    typealias Value = Comparable
    private let closure : @Sendable ([Model]) async -> [Model]
    
    let order : SortOrder
    
    
    init<T:Comparable>(_ item : SortableKeyPath<Model,T> , order : SortOrder = .ascending) {
        self.order = order
        closure = { models in
            models.sorted { first, second in
                let value1 = item.value(for: first)
                let value2 = item.value(for: second)
                if order == .ascending{
                    return value1 > value2
                }else{
                    return value1 < value2
                }
            }
        }
    }
    
    func sorted(_ models : [Model]) async -> [Model] {
            return await closure(models)
    }
    
}
