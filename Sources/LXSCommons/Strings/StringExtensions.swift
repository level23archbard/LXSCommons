//
//  StringExtensions.swift
//  LXSCommons
//
//  Created by Alex Rote on 12/5/19.
//

public extension StringProtocol {
    
    private func convertIndex(from index: Int) -> Index {
        return self.index(startIndex, offsetBy: index)
    }
    
    subscript(_ index: Int) -> Element {
        get {
            return self[convertIndex(from: index)]
        }
    }
    
    subscript(_ range: Range<Int>) -> SubSequence {
        get {
            let lower = convertIndex(from: range.lowerBound)
            return self[lower..<self.index(lower, offsetBy: range.upperBound - range.lowerBound)]
        }
    }
    
    subscript(_ range: ClosedRange<Int>) -> SubSequence {
        get {
            let lower = convertIndex(from: range.lowerBound)
            return self[lower...self.index(lower, offsetBy: range.upperBound - range.lowerBound)]
        }
    }
    
    subscript(_ range: PartialRangeUpTo<Int>) -> SubSequence {
        get {
            return self[..<convertIndex(from: range.upperBound)]
        }
    }
    
    subscript(_ range: PartialRangeThrough<Int>) -> SubSequence {
        get {
            return self[...convertIndex(from: range.upperBound)]
        }
    }
    
    subscript(_ range: PartialRangeFrom<Int>) -> SubSequence {
        get {
            return self[convertIndex(from: range.lowerBound)...]
        }
    }
}
