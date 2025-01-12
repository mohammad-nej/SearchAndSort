//
//  ValuePresentable.swift
//  SearchAndSort
//
//  Created by MohammavDev on 1/12/25.
//

public protocol ValuePresentable {
    associatedtype Model : Sendable
    associatedtype Value
    
    func value(for model : Model) -> Value
}
