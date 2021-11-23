//
//  TestVersion.swift
//  
//
//  Created by Alex Rote on 11/22/21.
//

import XCTest
import LXSCommons

class TestVersion: XCTestCase {
    
    func testBasics() {
        let version: Version = "1.0"
        XCTAssertEqual(version.majorValue, 1)
        XCTAssertEqual(version.minorValue, 0)
        XCTAssertEqual(version.patchValue, nil)
    }
    
    func testCompare() {
        let v123: Version = "1.2.3"
        XCTAssert(v123 < "1.2")
        XCTAssert(v123 > "1.2.0")
        XCTAssert(v123 < "1.3.0")
        XCTAssert(v123 < "1.3")
        let v11: Version = "1.1"
        let v120: Version = "1.2.0"
        XCTAssertTrue(v11 < v120)
        XCTAssertFalse(v11 > v120)
        XCTAssertFalse(v120 < v11)
        XCTAssertTrue(v120 > v11)
        
        let v12: Version = "1.2"
        XCTAssertTrue(v12.isLower(than: "1.3"))
        XCTAssertFalse(v12.isLower(than: "1.1"))
        XCTAssertTrue(v12.isLower(than: "1"))
        XCTAssertTrue(v12.isLower(than: "2"))
        XCTAssertFalse(v12.isLower(than: "1.2.0"))
        XCTAssertFalse(v12.isLower(than: "1.2"))
        
        XCTAssertFalse(v12.isHigher(than: "1.3"))
        XCTAssertTrue(v12.isHigher(than: "1.1"))
        XCTAssertTrue(v12.isHigher(than: "1"))
        XCTAssertFalse(v12.isHigher(than: "2"))
        XCTAssertFalse(v12.isHigher(than: "1.2.0"))
        XCTAssertFalse(v12.isHigher(than: "1.2"))
        
        XCTAssertFalse(v12.isWithin("1.3"))
        XCTAssertFalse(v12.isWithin("1.1"))
        XCTAssertTrue(v12.isWithin("1"))
        XCTAssertFalse(v12.isWithin("2"))
        XCTAssertTrue(v12.isWithin("1.2.0"))
        XCTAssertTrue(v12.isWithin("1.2"))
        
        XCTAssertTrue(v12.isBounded(by: "1.1"..<"1.3"))
        XCTAssertFalse(v12.isBounded(by: "1.0"..<"1.1"))
        XCTAssertFalse(v12.isBounded(by: "1.3"..<"2.0"))
        XCTAssertTrue(v12.isBounded(by: "1"..<"2"))
        XCTAssertTrue(v12.isBounded(by: "0"..<"1"))
        XCTAssertFalse(v12.isBounded(by: "2"..<"3"))
        XCTAssertTrue(v12.isBounded(by: "1.2"..<"2"))
        XCTAssertFalse(v12.isBounded(by: "1.0"..<"1.2"))
        XCTAssertTrue(v12.isBounded(by: "1.2.0"..<"2"))
        XCTAssertFalse(v12.isBounded(by: "1.0"..<"1.2.0"))
        
        XCTAssertTrue(v12.isBounded(by: "1.1"..."1.3"))
        XCTAssertFalse(v12.isBounded(by: "1.0"..."1.1"))
        XCTAssertFalse(v12.isBounded(by: "1.3"..."2.0"))
        XCTAssertTrue(v12.isBounded(by: "1"..."2"))
        XCTAssertTrue(v12.isBounded(by: "0"..."1"))
        XCTAssertFalse(v12.isBounded(by: "2"..."3"))
        XCTAssertTrue(v12.isBounded(by: "1.2"..."2"))
        XCTAssertTrue(v12.isBounded(by: "1.0"..."1.2"))
        XCTAssertTrue(v12.isBounded(by: "1.2.0"..."2"))
        XCTAssertTrue(v12.isBounded(by: "1.0"..."1.2.0"))
        
        XCTAssertTrue(v12.isBounded(by: "1.1"...))
        XCTAssertTrue(v12.isBounded(by: "1.0"...))
        XCTAssertFalse(v12.isBounded(by: "1.3"...))
        XCTAssertTrue(v12.isBounded(by: "1"...))
        XCTAssertTrue(v12.isBounded(by: "0"...))
        XCTAssertFalse(v12.isBounded(by: "2"...))
        XCTAssertTrue(v12.isBounded(by: "1.2"...))
        XCTAssertTrue(v12.isBounded(by: "1.0"...))
        XCTAssertTrue(v12.isBounded(by: "1.2.0"...))
        XCTAssertTrue(v12.isBounded(by: "1.0"...))
        
        XCTAssertTrue(v12.isBounded(by: ..<"1.3"))
        XCTAssertFalse(v12.isBounded(by: ..<"1.1"))
        XCTAssertTrue(v12.isBounded(by: ..<"2.0"))
        XCTAssertTrue(v12.isBounded(by: ..<"2"))
        XCTAssertTrue(v12.isBounded(by: ..<"1"))
        XCTAssertTrue(v12.isBounded(by: ..<"3"))
        XCTAssertTrue(v12.isBounded(by: ..<"2"))
        XCTAssertFalse(v12.isBounded(by: ..<"1.2"))
        XCTAssertTrue(v12.isBounded(by: ..<"2"))
        XCTAssertFalse(v12.isBounded(by: ..<"1.2.0"))
        
        XCTAssertTrue(v12.isBounded(by: ..."1.3"))
        XCTAssertFalse(v12.isBounded(by: ..."1.1"))
        XCTAssertTrue(v12.isBounded(by: ..."2.0"))
        XCTAssertTrue(v12.isBounded(by: ..."2"))
        XCTAssertTrue(v12.isBounded(by: ..."1"))
        XCTAssertTrue(v12.isBounded(by: ..."3"))
        XCTAssertTrue(v12.isBounded(by: ..."2"))
        XCTAssertTrue(v12.isBounded(by: ..."1.2"))
        XCTAssertTrue(v12.isBounded(by: ..."2"))
        XCTAssertTrue(v12.isBounded(by: ..."1.2.0"))
    }
}
