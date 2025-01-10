//
//  Sorter.swift
//  SearchAndSort
//
//  Created by MohammavDev on 1/10/25.
//

//
//  Sorter.swift
//  MelikaArt
//
//  Created by MohammavDev on 12/17/24.
//

import Foundation

public protocol Numbered {
    var number : Int { get}
}

@frozen public enum SortOrder : String , CaseIterable, Identifiable  {
    public var id: Self { self }
    
    case ascending = "صعودی" , descending = "نزولی"
    
    
}
public struct SortableKeyPath<Model : Sendable,Key:Comparable>  : Sendable{
    
    let key : KeyPath<Model, Key > 
    
    func value(for model : Model) -> some Comparable {
        model[keyPath: key]
    }
    
    init(_ key: KeyPath<Model,Key> ) {
        self.key = key
    }
}


public final actor Sorter<T : Sendable> where T : Numbered {
    
   
    
    init(models: [T], keys: [AnySorter<T>]) {
        self.models = models
        
        var allKeys = keys
    
//        if keys.contains(\.number) {
//            allKeys.append(\.number)
//        }
        self.sorters = allKeys
        
        
        self.selectedKey = \.number
        self.sortOrder = .ascending
    }
    
    let models : [T]
    
    let sorters : [AnySorter<T>]
    
    
    
    var selectedKey : PartialKeyPath<T>
    var sortOrder : SortOrder = .descending
    
    
//    func sort(by key : AnySearchableKey<T>) async -> [T] {
//        let allModels = self.models
//        let sorOrder = sortOrder
//        guard !allModels.isEmpty else { return []}
////        let task = Task.detached(priority: .userInitiated) { () -> [T] in
////            var results : [T] = []
////            let firstOne = allModels.first!
////            let value = firstOne[keyPath: key]
////            
//////            if value is  (any Comparable) {
//////                
//////            }
////            
////            return results
////        }
//        
//    }
//    func sort() async -> [T] {
//        
//            let models = self.models
//            
//            
//            let sortOrder = sortOrder
//        
//                
//                if let stringKey = selectedKey as? KeyPath<T,String> {
//                    return models.sorted { first , second in
//                        if sortOrder == .ascending {
//                            return first[keyPath: stringKey] < second[keyPath: stringKey]
//                        }else {
//                            return first[keyPath: stringKey] < second[keyPath: stringKey]
//                        }
//                    }
//                }
//                if let key = selectedKey as? KeyPath<T,Int> {
//                    return models.sorted { first , second in
//                        if sortOrder == .ascending {
//                            return first[keyPath: key] < second[keyPath: key]
//                        }else {
//                            return first[keyPath: key] < second[keyPath: key]
//                        }
//                    }
//                }
//                if let key = selectedKey as? KeyPath<T,Double> {
//                    return models.sorted { first , second in
//                        if sortOrder == .ascending {
//                            return first[keyPath: key] < second[keyPath: key]
//                        }else {
//                            return first[keyPath: key] < second[keyPath: key]
//                        }
//                    }
//                }
//                if let key = selectedKey as? KeyPath<T,Date> {
//                    return models.sorted { first , second in
//                        if sortOrder == .ascending {
//                            return first[keyPath: key] < second[keyPath: key]
//                        }else {
//                            return first[keyPath: key] < second[keyPath: key]
//                        }
//                    }
//                }
//                //if its an unknow type we simply return the array
//                logger.warning("The sort type is unknown, returning the array")
//                return models
//            }
            
        
    
}
