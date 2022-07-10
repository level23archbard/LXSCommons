//
//  TestArrays.swift
//  LXSCommons
//
//  Created by Alex Rote on 7/10/22.
//

import XCTest
@testable import LXSJson

final class LXSJsonTestArrays: XCTestCase {
    
    func testFind() {
        let arr: JSON = [1, "2", .null]
        XCTAssertEqual(arr.find { $0 == "2" }, "2")
        XCTAssertEqual(arr.find { $0 == "1" }, .undefined)
    }
}
