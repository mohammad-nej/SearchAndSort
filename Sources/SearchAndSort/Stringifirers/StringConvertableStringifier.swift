//
//  StringConvertableStringifier.swift
//  SearchAndSort
//
//  Created by MohammavDev on 1/14/25.
//

///Creates a Stringifier which returns [model.description] as output
public struct StringConvertableStringifier< T : CustomStringConvertible> : Stringifier {
    public func stringify(_ model: T) -> [String] {
        return [model.description]
    }
    
    public typealias Model = T
    
    
    
    
}
