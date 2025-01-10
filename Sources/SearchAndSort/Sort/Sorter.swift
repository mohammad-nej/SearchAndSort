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

@frozen public enum SortOrder : String , CaseIterable, Identifiable  {
    public var id: Self { self }
    
    case ascending = "صعودی" , descending = "نزولی"
    
    
}



public final actor Sorter<T : Sendable> {
    
   
    
    init() {
  
    }

    func sort(_ models : [T] ,  by sorter : AnySorter<T>) async -> [T] {
       return await Task.detached {
            return await sorter.sorted(models)
        }.value
        
        
    }
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
