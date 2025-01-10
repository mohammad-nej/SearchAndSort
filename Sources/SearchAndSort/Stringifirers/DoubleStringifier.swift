//
//  DoubleStringifier.swift
//  SearchAndSort
//
//  Created by MohammavDev on 1/8/25.
//

import Foundation

public struct DoubleStringifier : Stringifier {
    
    
    
    var includePersian : Bool = true
    public func stringify(_ model: Double) -> [String] {
        var results : [String] = []
        
        let formatter = NumberFormatter()
        formatter.locale = .init(identifier: "fa_IR")
        formatter.numberStyle = .decimal
        if includePersian{
            let formatted = formatter.string(from: model as NSNumber)
            if let formatted {
                results.append(formatted)
            }
            
            formatter.numberStyle = .none
            let formatted2 = formatter.string(from: model as NSNumber)
            if let formatted2 {
                results.append(formatted2)
            }
        }
        
        results.append(model.description)
        
        formatter.locale = .current
        
        let formatted3 = formatter.string(from: model as NSNumber)
        if let formatted3 {
            results.append(formatted3)
        }
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


