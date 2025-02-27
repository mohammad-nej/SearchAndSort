//
//  PersianIntStringifier.swift
//  SearchAndSort
//
//  Created by MohammavDev on 1/9/25.
//

import Foundation

public struct PersianIntStringifier : Stringifier, Sendable {
    public let id : UUID = UUID()
    public func stringify(_ model: Int) -> [String] {
        var results = [model.formatted(),model.description]
        
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
public extension Stringifier where Self == PersianIntStringifier {
    static var persian : Self { .init()}
}
public struct NullablePersianIntStringifier : Stringifier, Sendable {
    public let id : UUID = UUID()
    public func stringify(_ model: Int?) -> [String] {
        guard let model else {
            return ["nil"]
        }
        var results = [model.formatted(),model.description]
        
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
public extension Stringifier where Self == NullablePersianIntStringifier {
    static var persian : Self { .init()}
}
