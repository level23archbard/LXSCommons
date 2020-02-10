//
//  Vector.swift
//  LXSCommons
//
//  Created by Alex Rote on 4/29/18.
//  Copyright © 2018 Alex Rote. All rights reserved.
//

import Foundation
import Accelerate
import LXSCommons

struct Vector: Equatable, CustomStringConvertible {
    
    private var pointer: MemoryManagedPointer<Scalar>
    let length: Int
    
    init(length: Int, constructor: ((Index) -> Scalar)? = nil) {
        guard length > 0 else {
            fatalError()
        }
        self.length = length
        pointer = MemoryManagedPointer<Scalar>(capturedPointer: UnsafeMutablePointer<Scalar>.allocate(capacity: length))
        if let constructor = constructor {
            indices.forEach { self[$0] = constructor($0) }
        } else {
            pointer.bytes.initialize(repeating: 0, count: length)
        }
    }
    
    init(literal: [Scalar]) {
        self.init(length: literal.count) { (index) -> Scalar in
            return literal[index]
        }
    }
    
    // MARK: - Memory Managed Pointer
    
    private mutating func copyPointer() {
        let newBytes = UnsafeMutablePointer<Scalar>.allocate(capacity: length)
        newBytes.initialize(from: pointer.bytes, count: length)
        pointer = MemoryManagedPointer<Scalar>(capturedPointer: newBytes)
    }
    
    // MARK: - Index
    
    typealias Index = Int
    
    subscript(index: Index) -> Scalar {
        get {
            guard index >= 0 && index < length else {
                fatalError()
            }
            return pointer.bytes[index]
        }
        mutating set {
            guard index >= 0 && index < length else {
                fatalError()
            }
            if !isKnownUniquelyReferenced(&pointer) {
                copyPointer()
            }
            pointer.bytes[index] = newValue
        }
    }
    
    var indices: IndexSequence {
        return IndexSequence(length: length)
    }
    
    struct IndexSequence: Sequence, IteratorProtocol {
        
        private var i: Int
        private let length: Int
        fileprivate init(length: Int) {
            i = 0
            self.length = length
        }
        
        typealias Element = Index
        
        mutating func next() -> Vector.Index? {
            guard i < length else { return nil }
            let index = i
            i += 1
            return index
        }
    }
    
    var maxIndices: [Index] {
        var maxValue = -Scalar.greatestFiniteMagnitude
        var maxIndices = [Index]()
        for index in indices {
            let value = pointer.bytes[index]
            if value > maxValue {
                maxIndices.removeAll()
                maxIndices.append(index)
                maxValue = value
            } else if value == maxValue {
                maxIndices.append(index)
            }
        }
        return maxIndices
    }
    
    // MARK: - Dot
    
    static func •(left: Vector, right: Vector) -> Scalar {
        guard left.length == right.length else {
            fatalError()
        }
        return cblas_ddot(Int32(left.length), left.pointer.bytes, 1, right.pointer.bytes, 1)
    }
    
    // MARK: - Equatable
    
    static func ==(left: Vector, right: Vector) -> Bool {
        guard left.length == right.length else { return false }
        if left.pointer === right.pointer { return true }
        for index in left.indices {
            guard left[index] == right[index] else { return false }
        }
        return true
    }
    
    // MARK: - Custom String Convertible
    
    var description: String {
        var description = "Vector length \(length)\n⟨"
        for index in indices {
            if index != 0 {
                description += ", "
            }
            description += "\(self[index])"
        }
        description += "⟩"
        return description
    }
    
    // MARK: - Conversions
    
    var rowMatrix: Matrix {
        return Matrix(rows: 1, columns: length, constructor: { (index) -> Scalar in
            return self[index.j]
        })
    }
    
    var columnMatrix: Matrix {
        return Matrix(rows: length, columns: 1, constructor: { (index) -> Scalar in
            return self[index.i]
        })
    }
}
