//
//  DoubleStringifier.swift
//  SearchAndSort
//
//  Created by MohammavDev on 1/8/25.
//

import Foundation

public struct DoubleStringifier : Stringifier {
    
    
    
    public func stringify(_ model: Double) -> [String] {
        var results : [String] = []
    
        
        results.append(model.description)
        results.append(model.formatted())
        
        return results
    }
    
    
    
}

public extension Stringifier where Self == DoubleStringifier {
    static var `default` : Self { .init()}
}

public extension TitledKey where Key == Double {
    
    init(title : String , key : KeyPath<Model,Key>    , stringifier : Stringified = .default){
        self.title = title
        self.key = key
        self.stringer = stringifier
    }
    
    
}


