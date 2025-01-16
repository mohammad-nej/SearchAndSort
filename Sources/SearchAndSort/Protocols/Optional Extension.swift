//
//  Optionals.swift
//  SearchAndSort
//
//  Created by MohammavDev on 1/16/25.
//


///This extension let you use Optional KeyPaths
extension Optional : @retroactive CustomStringConvertible where Wrapped : CustomStringConvertible {
    public var description: String {
        return self?.description ?? "nil"
    }
    
    
}
extension Optional : @retroactive Comparable where Wrapped : Comparable {
    public static func < (lhs: Optional, rhs: Optional) -> Bool {
        //This sort always put nil values at the bottom
        //1. if both values are not nil , it will simply compare them
        //2. if both values are nil , it will not change their order
        //3. if lhs is nil, it will be qualified as smaller one
        //4. if rhs is nil , it will be qualified as smaller one
        
        // if both have valid values
        if let lhsValue = lhs, let rhsValue = rhs {
            return lhsValue < rhsValue
        }
        //if rhs is nil , we put it last
        if  rhs == nil {
            return false
        }
        //if lhs is nil , we put it last
        return true
    }
    
    
}
