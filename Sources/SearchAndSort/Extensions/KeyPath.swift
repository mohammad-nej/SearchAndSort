//
//  KeyPath.swift
//  SearchAndSort
//
//  Created by MohammavDev on 1/9/25.
//

extension KeyPath: @unchecked @retroactive Sendable where Root : Sendable{}

extension PartialKeyPath : @unchecked @retroactive Sendable where Root : Sendable {}
