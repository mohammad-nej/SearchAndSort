//
//  PersianDoubleStringifier.swift
//  SearchAndSort
//
//  Created by MohammavDev on 1/9/25.
//
import Foundation
public struct PersianDoubleStringifier : Stringifier , Sendable {
    static let persian : PersianDoubleStringifier = .init() 
    public func stringify(_ model: Double) -> [String] {
        var results : [String] = DoubleStringifier().stringify(model)
        
        let formatter = NumberFormatter()
        formatter.locale = .init(identifier: "fa_IR")
        formatter.numberStyle = .decimal
        formatter.decimalSeparator = "."
      
        let formatted = formatter.string(from: model as NSNumber)
        if let formatted {
            results.append(formatted)
        }
            
        formatter.numberStyle = .none
        let formatted2 = formatter.string(from: model as NSNumber)
        if let formatted2 {
            results.append(formatted2)
        }
        return results
        
    }
    
    public typealias Model = Double
    
}
public extension Stringifier where Model == Double {
   
}

