//
//  TestGrid.swift
//  LXSCommons
//
//  Created by Alex Rote on 6/28/22.
//

import XCTest
@testable import LXSGridGeometry

class TestGrid: XCTestCase {
    
    func testGrid() {
        let testGrid = Grid(rect: .zero, initialValue: 42)
        XCTAssertEqual(testGrid.rect, .zero)
        
        let testGrid2 = Grid(size: Size(width: 2, height: 3), initialValue: 42)
        XCTAssertEqual(testGrid2.count, 6)
        var timesLooped = 0
        for value in testGrid2 {
            XCTAssertEqual(value, 42)
            timesLooped += 1
        }
        XCTAssertEqual(timesLooped, 6)
        
        var testGrid3 = Grid(rect: Rect(x: 1, y: 2, width: 3, height: 4), initialValue: 0)
        let testPoint = Point(x: 3, y: 2)
        testGrid3[testPoint] = 1
        for point in testGrid3.rect.rowByRow {
            if point == testPoint {
                XCTAssertEqual(testGrid3[point], 1)
            } else {
                XCTAssertEqual(testGrid3[point], 0)
            }
        }
        
        var testGrid4 = Grid(rect: Rect(x: -2, y: -2, width: 4, height: 3), initialValue: 0)
        let testPoint4 = Point.zero
        testGrid4[testPoint4] = 1
        for point in testGrid4.rect.columnByColumn {
            if point == testPoint4 {
                XCTAssertEqual(testGrid4[point], 1)
            } else {
                XCTAssertEqual(testGrid4[point], 0)
            }
        }
    }
}
