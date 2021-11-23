//
//  SwiftExtensions.swift
//  LXSCommons
//
//  Created by Alex Rote on 5/1/16.
//  Copyright © 2016 Alex Rote. All rights reserved.
//

// Extensions relating to core protocols
// Stridable
// Collection
// RangeReplaceableCollection

// MARK: - Protocols

public extension Comparable {
    
    func bounded(by bounds: ClosedRange<Self>) -> Self {
        return min(max(self, bounds.lowerBound), bounds.upperBound)
    }
    
    func bounded(by bounds: PartialRangeFrom<Self>) -> Self {
        return max(self, bounds.lowerBound)
    }
    
    func bounded(by bounds: PartialRangeThrough<Self>) -> Self {
        return min(self, bounds.upperBound)
    }
    
    func isBounded(by bounds: Range<Self>) -> Bool {
        return bounds.contains(self)
    }
    
    func isBounded(by bounds: ClosedRange<Self>) -> Bool {
        return bounds.contains(self)
    }
    
    func isBounded(by bounds: PartialRangeFrom<Self>) -> Bool {
        return bounds.contains(self)
    }
    
    func isBounded(by bounds: PartialRangeUpTo<Self>) -> Bool {
        return bounds.contains(self)
    }
    
    func isBounded(by bounds: PartialRangeThrough<Self>) -> Bool {
        return bounds.contains(self)
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

public extension RangeReplaceableCollection {
    
    @discardableResult mutating func removeFirst(objectWhere predicate: (Element) throws -> Bool) rethrows -> Element? {
        if let index = try firstIndex(where: predicate) {
            return remove(at: index)
        } else {
            return nil
        }
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

public extension Dictionary {
    
    init<S>(takingFirst keysAndValues: S) where S : Sequence, S.Element == (Key, Value) {
        self = Dictionary(keysAndValues, uniquingKeysWith: { first, _ in first })
    }
    
    init<S>(takingLast keysAndValues: S) where S : Sequence, S.Element == (Key, Value) {
        self = Dictionary(keysAndValues, uniquingKeysWith: { _, last in last })
    }
    
    func mapKeys<K>(_ transform: (Key) throws -> K) rethrows -> [K : Value] {
        return Dictionary<K, Value>(takingFirst: try self.map { key, value in (try transform(key), value) })
    }
    
    func compactMapKeys<K>(_ transform: (Key) throws -> K?) rethrows -> [K : Value] {
        return Dictionary<K, Value>(takingFirst: try self.compactMap { key, value in
            if let k = try transform(key) {
                return (k, value)
            } else {
                return nil
            }
        })
    }
}

public extension LosslessStringConvertible {
    
    init?(_ description: String?) {
        if let description = description {
            self.init(description)
        } else {
            return nil
        }
    }
}
