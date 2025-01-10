//
//  Untitled.swift
//  SearchAndSort
//
//  Created by MohammavDev on 1/8/25.
//
import Foundation



public extension Stringifier where Self == IntStringifier   {
    static var `default` : IntStringifier {  IntStringifier() }
}
public extension TitledKey where Key == Int {
    init(title : String , key : KeyPath<Model,Int>   , stringifier : Stringified = .default) {
        self.title = title
        self.key = key
        self.stringer = stringifier
    }
}



public extension Stringifier where Self == StringStringifier {
    static var `default` : StringStringifier { StringStringifier()}
}
public extension TitledKey where Key == String {
    init(title : String , key : KeyPath<Model,Key>    , stringifier : Stringified = .default) {
        self.title = title
        self.key = key
        self.stringer = stringifier
    }

}



public extension Stringifier where Self == DateStringifier {
    static var `default` : DateStringifier { .init()}
}
public extension TitledKey where Key == Date {
    init(title : String , key : KeyPath<Model,Date>    , stringifier : Stringified = .default) {
        self.title = title
        self.key = key
        self.stringer = stringifier
    }
    
}
