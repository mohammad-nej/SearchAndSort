//
//  Stringifier.swift
//  SearchAndSort
//
//  Created by MohammavDev on 1/9/25.
//


import Foundation
import Foundation

public protocol Stringifier : Sendable , Identifiable , Equatable {
    
    associatedtype Model 
    
    var id : UUID { get }
    
    func stringify(_ model : Model) -> [String]
}



