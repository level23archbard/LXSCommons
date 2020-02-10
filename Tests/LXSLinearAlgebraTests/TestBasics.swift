//
//  TestBasics.swift
//  LXSCommons
//
//  Created by Alex Rote on 2/9/20.
//

import XCTest
@testable import LXSLinearAlgebra

final class LXSLinearAlgebraTests: XCTestCase {
    
    func testVectorStruct() {
           var vector = Vector(length: 8)
           vector[1] = 2
           vector[2] = 4
           vector[3] = 8
           var anotherVector = vector
           vector[4] = 16
           anotherVector[3] = 5
           print(vector)
           print(anotherVector)
           XCTAssert(vector.length == 8)
           XCTAssert(vector[0] == 0)
           XCTAssert(vector[1] == 2)
           XCTAssert(vector[2] == 4)
           XCTAssert(vector[3] == 8)
           XCTAssert(vector[4] == 16)
           XCTAssert(vector[5] == 0)
           XCTAssert(vector[6] == 0)
           XCTAssert(vector[7] == 0)
           XCTAssert(anotherVector.length == 8)
           XCTAssert(anotherVector[0] == 0)
           XCTAssert(anotherVector[1] == 2)
           XCTAssert(anotherVector[2] == 4)
           XCTAssert(anotherVector[3] == 5)
           XCTAssert(anotherVector[4] == 0)
           XCTAssert(anotherVector[5] == 0)
           XCTAssert(anotherVector[6] == 0)
           XCTAssert(anotherVector[7] == 0)
           XCTAssert(vector != anotherVector)
           anotherVector[3] = 8
           XCTAssert(vector != anotherVector)
           anotherVector[4] = 16
           XCTAssert(vector == anotherVector)
           var aThirdVector = vector
           let result = vector == aThirdVector
           XCTAssert(result)
           aThirdVector[0] = 4
           aThirdVector[7] = 16
           XCTAssertEqual(aThirdVector.maxIndices, [4,7])
           let dotProduct = vector • anotherVector
           XCTAssertEqual(dotProduct, 340)
       }
       
       func testMatrixStruct() {
           var matrix = Matrix(rows: 2, columns: 3)
           matrix[0, 1] = 4
           matrix[0, 2] = 6
           matrix[1, 2] = 8
           var anotherMatrix = matrix
           anotherMatrix[0, 0] = 2
           anotherMatrix[0, 1] = 3
           print(matrix)
           print(anotherMatrix)
           XCTAssertNotEqual(matrix, anotherMatrix)
           anotherMatrix[0, 1] = 4
           matrix[0, 0] = 2
           XCTAssertEqual(matrix, anotherMatrix)
           let columnMatrix = Vector(length: 3) { _ in 4.0 }.columnMatrix
           print(columnMatrix)
           XCTAssertEqual(columnMatrix[0, 0], 4.0)
           XCTAssertEqual(columnMatrix[1, 0], 4.0)
           XCTAssertEqual(columnMatrix[2, 0], 4.0)
           let resultMatrix = matrix * columnMatrix
           print(resultMatrix)
           XCTAssertEqual(resultMatrix.rows, 2)
           XCTAssertEqual(resultMatrix.columns, 1)
           XCTAssertEqual(resultMatrix[0, 0], 48.0)
           XCTAssertEqual(resultMatrix[1, 0], 32.0)
       }
       
       func testPerformanceMatrixMultiply() {
           let firstMatrix = Matrix(rows: 800, columns: 500) { (index) -> Scalar in
               return Scalar(index.i + index.j)
           }
           let secondMatrix = Matrix(rows: 500, columns: 1300) { (index) -> Scalar in
               return Scalar(1 + index.i)
           }
           self.measure {
               let _ = firstMatrix * secondMatrix
           }
       }
       
       func testPerformanceMatrixSlowMultiply() {
           let firstMatrix = Matrix(rows: 80, columns: 50) { (index) -> Scalar in
               return Scalar(index.i + index.j)
           }
           let secondMatrix = Matrix(rows: 50, columns: 130) { (index) -> Scalar in
               return Scalar(1 + index.i)
           }
           self.measure {
               let _ = Matrix(rows: firstMatrix.rows, columns: secondMatrix.columns, constructor: { (index) -> Scalar in
                   return firstMatrix.rowVector(at: index.i) • secondMatrix.columnVector(at: index.j)
               })
           }
       }
}
