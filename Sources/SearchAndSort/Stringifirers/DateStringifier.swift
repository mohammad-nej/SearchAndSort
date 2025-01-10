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
        
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        
        results.append( formatter.string(from: model))
        
        formatter.dateStyle = .medium
        results.append(formatter.string(from: model))
        
        formatter.dateStyle = .long
        results.append(formatter.string(from: model))
        
        formatter.dateStyle = .medium
        results.append(formatter.string(from: model))
         
        return results
    }
    
    
}


