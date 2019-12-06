//
//  Matrix.swift
//  LXSCommons
//
//  Created by Alex Rote on 4/29/18.
//  Copyright © 2018 Alex Rote. All rights reserved.
//

import Foundation
import Accelerate

struct Matrix: Equatable, CustomStringConvertible {
    
    private var pointer: MemoryManagedPointer<Scalar>
    let rows: Int, columns: Int
    
    init(rows: Int, columns: Int, constructor: ((Index) -> Scalar)? = nil) {
        guard rows > 0, columns > 0 else {
            fatalError()
        }
        self.rows = rows
        self.columns = columns
        // Initializes the array with all values set to 0
        pointer = MemoryManagedPointer<Scalar>(capturedPointer: UnsafeMutablePointer<Scalar>.allocate(capacity: rows * columns))
        if let constructor = constructor {
            indices.forEach { self[$0] = constructor($0) }
        } else {
            pointer.bytes.initialize(repeating: 0, count: rows * columns)
        }
    }
    
    private init(rows: Int, columns: Int, pointer: MemoryManagedPointer<Scalar>) {
        self.rows = rows
        self.columns = columns
        self.pointer = pointer
    }
    
    // MARK: - Memory Managed Pointer
    
    private mutating func copyPointer() {
        let newBytes = UnsafeMutablePointer<Scalar>.allocate(capacity: rows * columns)
        newBytes.initialize(from: pointer.bytes, count: rows * columns)
        pointer = MemoryManagedPointer<Scalar>(capturedPointer: newBytes)
    }
    
    // MARK: - Index
    
    typealias Index = (i: Int, j: Int)
    
    subscript(index: Index) -> Scalar {
        get {
            guard index.i >= 0 && index.i < rows && index.j >= 0 && index.j < columns else {
                fatalError()
            }
            return pointer.bytes[index.i * columns + index.j]
        }
        mutating set {
            guard index.i >= 0 && index.i < rows && index.j >= 0 && index.j < columns else {
                fatalError()
            }
            if !isKnownUniquelyReferenced(&pointer) {
                copyPointer()
            }
            pointer.bytes[index.i * columns + index.j] = newValue
        }
    }
    
    subscript(indexI: Int, indexJ: Int) -> Scalar {
        get {
            return self[(indexI, indexJ)]
        }
        mutating set {
            self[(indexI, indexJ)] = newValue
        }
    }
    
    var indices: IndexSequence {
        return IndexSequence(rows: rows, columns: columns)
    }
    
    struct IndexSequence: Sequence, IteratorProtocol {
        
        private var i, j: Int
        private let rows, columns: Int
        fileprivate init(rows: Int, columns: Int) {
            i = 0
            j = 0
            self.rows = rows
            self.columns = columns
        }
        
        typealias Element = Index
        
        mutating func next() -> Matrix.Index? {
            guard i < rows else { return nil }
            let index = (i, j)
            j = (j + 1) % columns
            i += (j == 0 ? 1 : 0)
            return index
        }
    }
    
    // MARK: - Add
    
    static func +(left: Matrix, right: Matrix) -> Matrix {
        guard left.rows == right.rows, left.columns == right.columns else {
            fatalError()
        }
        return Matrix(rows: left.rows, columns: left.columns, constructor: { (index) -> Scalar in
            return left[index] + right[index]
        })
    }
    
    static func add(_ left: Matrix, _ right: Matrix) -> Matrix {
        return left + right
    }
    
    func added(with right: Matrix) -> Matrix {
        return self + right
    }
    
    // MARK: - Multiply
    
    static func *(left: Matrix, right: Matrix) -> Matrix {
        guard left.columns == right.rows else {
            fatalError()
        }
        let outPointer = UnsafeMutablePointer<Scalar>.allocate(capacity: left.rows * right.columns)
        outPointer.initialize(repeating: 0, count: left.rows * right.columns)
        cblas_dgemm(CblasRowMajor, CblasNoTrans, CblasNoTrans, Int32(left.rows), Int32(right.columns), Int32(left.columns), 1, left.pointer.bytes, Int32(left.columns), right.pointer.bytes, Int32(right.columns), 0, outPointer, Int32(right.columns))
        return Matrix(rows: left.rows, columns: right.columns, pointer: MemoryManagedPointer<Scalar>(capturedPointer: outPointer))
    }
    
    static func *(left: Scalar, right: Matrix) -> Matrix {
        return Matrix(rows: right.rows, columns: right.columns, constructor: { (index) -> Scalar in
            return left * right[index]
        })
    }
    
    static func *(left: Matrix, right: Scalar) -> Matrix {
        return Matrix(rows: left.rows, columns: left.columns, constructor: { (index) -> Scalar in
            return left[index] * right
        })
    }
    
    static func multiply(_ left: Matrix, _ right: Matrix) -> Matrix {
        return left * right
    }
    
    static func multiply(_ left: Scalar, _ right: Matrix) -> Matrix {
        return left * right
    }
    
    static func multiply(_ left: Matrix, _ right: Scalar) -> Matrix {
        return left * right
    }
    
    func multiplied(by right: Matrix) -> Matrix {
        return self * right
    }
    
    func multiplied(by right: Scalar) -> Matrix {
        return self * right
    }
    
    // MARK: - Element Multiply
    
    static func ⊙(left: Matrix, right: Matrix) -> Matrix {
        guard left.rows == right.rows, left.columns == right.columns else {
            fatalError()
        }
        return Matrix(rows: left.rows, columns: left.columns, constructor: { (index) -> Scalar in
            return left[index] * right[index]
        })
    }
    
    static func elementMultiply(_ left: Matrix, _ right: Matrix) -> Matrix {
        return left ⊙ right
    }
    
    func elementMultiplied(by right: Matrix) -> Matrix {
        return self ⊙ right
    }
    
    // MARK: - Transpose
    
    static postfix func ⊤(left: Matrix) -> Matrix {
        return Matrix(rows: left.columns, columns: left.rows, constructor: { (index) -> Scalar in
            return left[index.j, index.i]
        })
    }
    
    var transposed: Matrix {
        return self⊤
    }
    
    // MARK: - Equatable
    
    static func ==(left: Matrix, right: Matrix) -> Bool {
        guard left.rows == right.rows && left.columns == right.columns else { return false }
        if left.pointer === right.pointer { return true }
        for index in left.indices {
            guard left[index] == right[index] else { return false }
        }
        return true
    }
    
    // MARK: - Custom String Convertible
    
    var description: String {
        var description = "Matrix size \(rows)x\(columns)\n"
        for row in 0..<rows {
            let atTop = (row == 0)
            let atBottom = (row == rows - 1)
            if atTop && atBottom {
                description += "["
            } else if atTop {
                description += "⎡"
            } else if atBottom {
                description += "⎣"
            } else {
                description += "⎢"
            }
            for column in 0..<columns {
                if column != 0 {
                    description += ", "
                }
                description += "\(self[row, column])"
            }
            if atTop && atBottom {
                description += "]\n"
            } else if atTop {
                description += "⎤\n"
            } else if atBottom {
                description += "⎦\n"
            } else {
                description += "⎢\n"
            }
        }
        return description
    }
    
    // MARK: - Conversions
    
    func columnVector(at column: Int) -> Vector {
        return Vector(length: rows, constructor: { (index) -> Scalar in
            return self[(index, column)]
        })
    }
    
    func rowVector(at row: Int) -> Vector {
        return Vector(length: columns, constructor: { (index) -> Scalar in
            return self[(row, index)]
        })
    }
}
