//
//  SwiftExtensions.swift
//  LXSCommons
//
//  Created by Alex Rote on 5/1/16.
//  Copyright © 2016 Alex Rote. All rights reserved.
//

// Extensions relating to core structures
// Bool
// String
// Data
//
// Extensions relating to core protocols
// Stridable
// RangeReplaceableCollection

// MARK: - Structs

public extension Bool {
    
    static func random(probability: Probability) -> Bool {
        return Bool.random(with: Random.Binary(p: probability))
    }
    
    static func random(with generator: RandomBoolGenerator) -> Bool {
        return generator.bool()
    }
}

// MARK: - Protocols

public extension Strideable {
    
    func bounded(by bounds: ClosedRange<Self>) -> Self {
        return min(max(self, bounds.lowerBound), bounds.upperBound)
    }
    
    func isBounded(by bounds: ClosedRange<Self>) -> Bool {
        return bounds.lowerBound < self && self < bounds.upperBound
    }
}

public extension Collection {
    
    var nonEmpty: Self? {
        return isEmpty ? nil : self
    }
    
    var fullRange: Range<Index> {
        return startIndex..<endIndex
    }
}

public extension RangeReplaceableCollection where Element : Equatable {
    
    @discardableResult mutating func removeFirst(object: Element) -> Element? {
        if let index = firstIndex(of: object) {
            return remove(at: index)
        } else {
            return nil
        }
    }
}
