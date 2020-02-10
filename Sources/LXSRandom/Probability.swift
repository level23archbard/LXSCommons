//
//  Probability.swift
//  LXSCommons
//
//  Created by Alex Rote on 2/25/19.
//  Copyright © 2019 Alex Rote. All rights reserved.
//

import LXSCommons

public struct Probability: ExpressibleByFloatLiteral, ExpressibleByBooleanLiteral {
    
    // MARK: - Probability Constants
    
    public static let `true`: Probability = true
    public static let `false`: Probability = false
    public static let uncertain: Probability = 0.5
    
    // MARK: - Probability Initialization
    
    internal var p: Double
    
    public typealias FloatLiteralType = Double
    public typealias BooleanLiteralType = Bool
    
    public init(floatLiteral value: Probability.FloatLiteralType) {
        self.p = value.bounded(by: 0...1)
    }
    
    public init(booleanLiteral value: Probability.BooleanLiteralType) {
        self.p = value ? 1 : 0
    }
    
    public init<Source>(_ value: Source) where Source : BinaryFloatingPoint {
        self.p = Double(value).bounded(by: 0...1)
    }
    
    public init?<Source>(exactly value: Source) where Source: BinaryFloatingPoint {
        if value.isBounded(by: 0...1) {
            self.p = Double(value)
        } else {
            return nil
        }
    }
    
    public init(_ boolean: Bool) {
        self.p = boolean ? 1 : 0
    }
    
    private init(fast p: Double) {
        self.p = p
    }
    
    // MARK: - Probability Use
    
    public var isProbablyTrue: Bool {
        return p >= Probability.uncertain.p
    }
    
    public var isProbablyFalse: Bool {
        return p <= Probability.uncertain.p
    }
    
    // MARK: - Probability Operators
    
    public static prefix func ! (p: Probability) -> Probability {
        return Probability(fast: 1 - p.p)
    }
    
    public static func || (left: Probability, right: Probability) -> Probability {
        return !Probability(fast: (!left).p * (!right).p)
    }
    
    public static func && (left: Probability, right: Probability) -> Probability {
        return Probability(fast: left.p * right.p)
    }
}

// MARK: - Probability Comparing

extension Probability: Comparable {
    
    public static func == (left: Probability, right: Probability) -> Bool {
        return left.p == right.p
    }
    
    public static func != (left: Probability, right: Probability) -> Bool {
        return left.p != right.p
    }
    
    public static func < (left: Probability, right: Probability) -> Bool {
        return left.p < right.p
    }
    
    public static func <= (left: Probability, right: Probability) -> Bool {
        return left.p <= right.p
    }
    
    public static func > (left: Probability, right: Probability) -> Bool {
        return left.p > right.p
    }
    
    public static func >= (left: Probability, right: Probability) -> Bool {
        return left.p >= right.p
    }
}
