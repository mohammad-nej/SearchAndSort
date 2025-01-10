//
//  PersianIntStringifier.swift
//  SearchAndSort
//
//  Created by MohammavDev on 1/9/25.
//

import Foundation

public struct PersianIntStringifier : Stringifier, Sendable {
    static let persian : PersianIntStringifier = .init()
    public func stringify(_ model: Int) -> [String] {
        var results = IntStringifier().stringify(model)
        
        let formatter = NumberFormatter()
        formatter.locale = .init(identifier: "fa_IR")
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 0
        
        let converted = formatter.string(from: model as NSNumber)
        if let converted {
            results.append(converted)
        }
        return results
    }
}

