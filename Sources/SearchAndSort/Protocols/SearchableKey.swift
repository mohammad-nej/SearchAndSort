//
//  SearchableKey.swift
//  SearchAndSort
//
//  Created by MohammavDev on 1/8/25.
//


import Foundation
import Foundation

public protocol SearchableKey : Sendable where Stringer.Model == Key   {
    associatedtype Item : Sendable
    associatedtype Key
    associatedtype Stringer : Stringifier
    
    //associatedtype Stringified : Stringifier
    //var title : String { get}
    var key : KeyPath<Item , Key>  { get set}
    var stringer : Stringer { get}
    //var stringer :
    //func stringify(_ model : Model) -> [String]
}
extension SearchableKey {
    func stringify(_ model: Item) -> [String] {
        return stringer.stringify(model[keyPath:key])
    }
}
