//
//  StringConvertableStringifier.swift
//  SearchAndSort
//
//  Created by MohammavDev on 1/14/25.
//
import Foundation
///Creates a Stringifier which returns [model.description] as output
///
public struct StringConvertableStringifier< T : CustomStringConvertible> : Stringifier {
    public let id = UUID()
    public func stringify(_ model: T) -> [String] {
        return [model.description]
    }
    
    public typealias Model = T
    
    
    
    
}
//public struct NullableStringConvertableStringifier< T : Optionals> : Stringifier{
//    public let id = UUID()
//    public func stringify(_ model: T?) -> [String] {
//        guard let model = model else {
//            return []
//        }
//        return [model.opt. ?? "null"]
//    }
//    
//    public typealias Model = T?
//}
