//
//  PersianDateStringifier.swift
//  SearchAndSort
//
//  Created by MohammavDev on 1/9/25.
//

import Foundation


public struct PersianDateStringifier : Stringifier , Sendable {
    static let persian : PersianDateStringifier = .init()
    public func stringify(_ model: Date) -> [String] {
        var results : [String] = []
        let formatter = DateFormatter()
        
        formatter.locale = .init(identifier: "fa_IR")
        formatter.calendar = .init(identifier: .persian)
        
        formatter.dateFormat = "YYYY/MM/DD - HH:MM:SS"
        
        results.append(formatter.string(from: model))
        
        return results
    }
    
    
}
public extension Stringifier where Self == PersianDateStringifier {
    
}
