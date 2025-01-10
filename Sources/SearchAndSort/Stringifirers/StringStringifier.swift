//
//  StringStringifier.swift
//  SearchAndSort
//
//  Created by MohammavDev on 1/8/25.
//


import Foundation
import Foundation

public struct StringStringifier : Stringifier, Sendable {
    
    public func stringify(_ model: String) -> [String] {
        return [model]
    }
    
    public typealias Model = String
}
