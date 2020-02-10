//
//  Random.swift
//  LXSCommons
//
//  Created by Alex Rote on 3/4/15.
//  Copyright (c) 2015 Alex Rote. All rights reserved.
//

import CoreGraphics

public protocol RandomBoolGenerator {
    func bool() -> Bool
}

public struct Random {
    private init() {}
    
    // MARK: - Uniform
    
    // Uniform now leverages built-in uniform random methods
    public struct Uniform: RandomBoolGenerator {
        
        private init() {}
        
        public static let generator = Uniform()
        
        public static func int() -> Int {
            return generator.int()
        }
        
        public func int() -> Int {
            return Int.random(in: Int.min...Int.max)
        }
        
        public static func int(in range: ClosedRange<Int>) -> Int {
            return generator.int(in: range)
        }
        
        public func int(in range: ClosedRange<Int>) -> Int {
            return Int.random(in: range)
        }
        
        public static func int(in range: Range<Int>) -> Int {
            return generator.int(in: range)
        }
        
        public func int(in range: Range<Int>) -> Int {
            return Int.random(in: range)
        }
        
        public static func int64() -> Int64 {
            return generator.int64()
        }
        
        public func int64() -> Int64 {
            return Int64.random(in: Int64.min...Int64.max)
        }
        
        public static func int16() -> Int16 {
            return generator.int16()
        }
        
        public func int16() -> Int16 {
            return Int16.random(in: Int16.min...Int16.max)
        }
        
        public static func uint8() -> UInt8 {
            return generator.uint8()
        }
        
        public func uint8() -> UInt8 {
            return UInt8.random(in: UInt8.min...UInt8.max)
        }
        
        public static func bool() -> Bool {
            return generator.bool()
        }
        
        public func bool() -> Bool {
            return Bool.random()
        }
        
        public static func double() -> Double {
            return generator.double()
        }
        
        public func double() -> Double {
            return Double.random(in: 0..<1)
        }
        
        public static func cgFloat() -> CGFloat {
            return generator.cgFloat()
        }
        
        public func cgFloat() -> CGFloat {
            return CGFloat.random(in: 0..<1)
        }
        
        public static func cgFloat(in range: ClosedRange<CGFloat>) -> CGFloat {
            return generator.cgFloat(in: range)
        }
        
        public func cgFloat(in range: ClosedRange<CGFloat>) -> CGFloat {
            return CGFloat.random(in: range)
        }
        
        public static func cgVector() -> CGVector {
            return generator.cgVector()
        }
        
        public func cgVector() -> CGVector {
            return CGVector(magnitude: 1.0, rotation: cgFloat() * 2 * CGFloat.pi)
        }
    }
    
    // MARK: - Binary
    
    public struct Binary: RandomBoolGenerator {
        
        public var p: Probability = 0.5
        
        public init(p: Probability) {
            self.p = p
        }
        
        public init() {}
        
        public func bool() -> Bool {
            return Probability(Uniform.generator.double()) < p
        }
    }
}


