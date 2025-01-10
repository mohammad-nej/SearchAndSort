//
//  BoolStringifier.swift
//  SearchAndSort
//
//  Created by MohammavDev on 1/9/25.
//

public struct BoolStringifier : Stringifier, Sendable {
    
    
    public func stringify(_ model: Bool) -> [String] {
        return [model.description]
    }
    
}

public extension Stringifier where Self == BoolStringifier {
    static var `default` : BoolStringifier { .init()}
}

public extension TitledKey where Key == Bool {
    
    init(title : String , key : KeyPath<Model,Bool>    , stringifier : Stringified = .default) {
        self.title = title
        self.key = key
        self.stringer = stringifier
    }
}
