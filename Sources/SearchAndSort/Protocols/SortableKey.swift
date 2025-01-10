////
////  SortableKey.swift
////  SearchAndSort
////
////  Created by MohammavDev on 1/10/25.
////
//
//public protocol SortableKey : Sendable {
//     associatedtype Model
//     associatedtype Key : Comparable
//    
//     var key : KeyPath<Model,Key> { get }
//    
//}
//
//
//struct TitledSortableKey<Model : Sendable , Key : Comparable> : SortableKey{
//    
//    var key: KeyPath<Model, Key>
//}
//
//struct AnySortableKey<Model : Sendable> {
//    
//    private let stringProducer :  @Sendable (Root) -> [String]
//    
//    init<T : SearchableKey>(_ item : T) where T.Item == Root  {
//        self.stringProducer = { model in
//            return item.stringify(model)
//        }
//    }
//    
//    func stringify(_ model : Root ) -> [String] {
//        
//        stringProducer(model)
//    }
//    
//
//    
//    
//}
