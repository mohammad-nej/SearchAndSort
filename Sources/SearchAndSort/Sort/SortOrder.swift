////
////  Sorter.swift
////  SearchAndSort
////
////  Created by MohammavDev on 1/10/25.
////
//
////
////  Sorter.swift
////  MelikaArt
////
////  Created by MohammavDev on 12/17/24.
////
//
import Foundation
//
@frozen public enum SortOrder : String , CaseIterable, Identifiable  {
    public var id: Self { self }
    
    case ascending = "صعودی" , descending = "نزولی"
    
    
}
//
//
//
//public final actor Sorter<T : Sendable> {
//    
//   
//    
//    init() {
//  
//    }
//    init(_ model : T.Type){
//        
//    }
//
//    func sort(_ models : [T] ,  by sorter : AnySorter<T>) async -> [T] {
//       return await Task.detached {
//            return await sorter.sorted(models)
//        }.value
//        
//        
//    }
//}
