//
//  IntStringifier.swift
//  SearchAndSort
//
//  Created by MohammavDev on 1/8/25.
//


import Foundation
import Foundation

public struct IntStringifier : Stringifier, Sendable {
    public func stringify(_ model: Int) -> [String] {
        var results : [String] = []
        
        let formatter = NumberFormatter()
        formatter.locale = .init(identifier: "fa_IR")
        
        let stringed = formatter.string(from: model as NSNumber)
        
        if let stringed {
            results.append(stringed)
        }
        results.append(model.description)
        return results

    }
    
    //typealias Model = Int
}
