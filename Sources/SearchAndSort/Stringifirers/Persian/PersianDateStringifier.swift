//
//  PersianDateStringifier.swift
//  SearchAndSort
//
//  Created by MohammavDev on 1/9/25.
//

import Foundation


public struct PersianDateStringifier : Stringifier , Sendable {
    public let id : UUID = UUID()
    public func stringify(_ model: Date) -> [String] {
        var results : [String] = []
        let formatter = DateFormatter()
        
        formatter.locale = .init(identifier: "fa_IR")
        formatter.calendar = .init(identifier: .persian)
        
        formatter.dateFormat = "YYYY/MM/dd - hh:mm:ss"
        
        results.append(formatter.string(from: model))
        return results
    }
}
public extension Stringifier where Self == PersianDateStringifier {
    static var persian : Self { .init()}
}


public struct NullablePersianDateStringifier : Stringifier , Sendable {
    public let id : UUID = UUID()
    public func stringify(_ model: Date?) -> [String] {
        guard let model else { return ["nil"]}
        var results : [String] = []
        let formatter = DateFormatter()
        
        formatter.locale = .init(identifier: "fa_IR")
        formatter.calendar = .init(identifier: .persian)
        
        formatter.dateFormat = "YYYY/MM/dd - hh:mm:ss"
        
        results.append(formatter.string(from: model))
        return results
    }
}
public extension Stringifier where Self == NullablePersianDateStringifier {
    ///In case of being nil, it will return 'nil' as a string
    static var persian : Self { .init()}
}
