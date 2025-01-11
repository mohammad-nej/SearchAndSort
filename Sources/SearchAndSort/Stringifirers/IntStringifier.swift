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
        results.append(model.formatted())
        results.append(model.description)
        return results

    }

}
