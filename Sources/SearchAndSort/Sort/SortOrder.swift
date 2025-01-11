////
////  Sorter.swift
////  SearchAndSort
////
////  Created by MohammavDev on 1/10/25.
////
//

import Foundation

@frozen public enum SortOrder : String , CaseIterable, Identifiable  {
    public var id: Self { self }
    
    case ascending = "Ascending" , descending = "Descending"
}

