//
//  TestPoint.swift
//  LXSCommons
//
//  Created by Alex Rote on 6/29/22.
//

import XCTest
@testable import LXSGridGeometry

class TestPoint: XCTestCase {
    
    func testPoint() {
        var p = Point.zero
        XCTAssertEqual(p.x, 0)
        XCTAssertEqual(p.y, 0)
        XCTAssertEqual(p, Point(x: 0, y: 0))
        
        p = p.nextAlongX
        XCTAssertEqual(p, Point(x: 1, y: 0))
        
        p = p.previousAlongX
        XCTAssertEqual(p, Point(x: 0, y: 0))
        
        p = p.previousAlongY
        XCTAssertEqual(p, Point(x: 0, y: -1))
        
        p = p.nextAlongY
        XCTAssertEqual(p, Point(x: 0, y: 0))
        
        p = p.advancedAlongX(by: 3)
        XCTAssertEqual(p, Point(x: 3, y: 0))
        
        p = p.advancedAlongY(by: 4)
        XCTAssertEqual(p, Point(x: 3, y: 4))
        
        p = p.advanced(byX: 5, byY: -5)
        XCTAssertEqual(p, Point(x: 8, y: -1))
    }
}
