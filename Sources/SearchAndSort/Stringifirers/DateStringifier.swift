//
//  DateStringifier.swift
//  SearchAndSort
//
//  Created by MohammavDev on 1/9/25.
//

import Foundation


public struct DateStringifier : Stringifier , Sendable {
    
    public func stringify(_ model: Date) -> [String] {
        var results : [String] = [model.formatted()]
        
        return results
    }
    
    
}


