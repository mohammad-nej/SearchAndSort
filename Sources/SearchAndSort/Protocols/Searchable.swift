//
//  Searchable.swift
//  SearchAndSort
//
//  Created by MohammavDev on 1/15/25.
//

public protocol Searchable : Sendable {
    associatedtype Models : Sendable
    func search(in models : [Models] , for query : String , strategy : SearchStrategy ) async-> [Models]?
}
public protocol Sortable  : Sendable{
    associatedtype Models : Sendable
    func sort(_ models : [Models] , order : SortOrder ) async-> [Models]
    
}

public typealias SearchAndSortable = Searchable & Sortable


