//
//  TestExtensions.swift
//  LXSCommons
//
//  Created by Alex Rote on 6/19/18.
//  Copyright © 2018 Alex Rote. All rights reserved.
//

import XCTest
@testable import LXSCommons

class TestExtensions: XCTestCase {
    
    func testStrings() {
        let test = "simpleTest"
        XCTAssertEqual(test.count, 10)
        var iterations = 0
        for (index, char) in test.enumerated() {
            XCTAssertEqual(test[index], char)
            iterations += 1
        }
        XCTAssertEqual(test.count, iterations)
        
        let complexTest = "complëxTęßt     ™£¢∞§¶ªasdf💙🐱is🇸🇪too"
        XCTAssertEqual(complexTest.count, 35)
        iterations = 0
        for (index, char) in complexTest.enumerated() {
            XCTAssertEqual(complexTest[index], char)
            iterations += 1
        }
        XCTAssertEqual(complexTest.count, iterations)
        
        let testRange = complexTest[1..<34]
        XCTAssertEqual(testRange, complexTest.dropFirst().dropLast())
        let testRange2 = complexTest[1...34]
        XCTAssertEqual(testRange2, complexTest.dropFirst())
        let testRange3 = complexTest[1...]
        XCTAssertEqual(testRange3, complexTest.dropFirst())
        let testRange4 = complexTest[...34]
        XCTAssertEqual(testRange4, Substring(complexTest))
        let testRange5 = complexTest[..<34]
        XCTAssertEqual(testRange5, complexTest.dropLast())
    }
    
    func testRangeReplaceableCollectionRemoveObject() {
        var testArray = [3, 6, 9, 12]
        let originalCount = testArray.count
        var test = testArray.removeFirst(object: 6)
        XCTAssertEqual(testArray.count, originalCount - 1)
        XCTAssertEqual(test, 6)
        test = testArray.removeFirst(object: 9)
        XCTAssertEqual(testArray.count, originalCount - 2)
        XCTAssertEqual(test, 9)
        test = testArray.removeFirst(object: 10)
        XCTAssertEqual(testArray.count, originalCount - 2)
        XCTAssertEqual(test, nil)
    }
    
    func testStridableBounded() {
        let bounds = 3.0...9.0
        let test = 4.0
        XCTAssertEqual(test.bounded(by: bounds), 4)
        let test2 = 2.0
        XCTAssertEqual(test2.bounded(by: bounds), 3)
        let test3 = 10.0
        XCTAssertEqual(test3.bounded(by: bounds), 9)
    }
}
