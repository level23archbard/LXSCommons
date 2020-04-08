//
//  TestDataExtensions.swift
//  LXSCommons
//
//  Created by Alex Rote on 2/11/20.
//


import XCTest
@testable import LXSCommons

class TestDataExtensions: XCTestCase {
    
    func testHexEncodedString() {
        let baseDataString = "Hello World!"
        guard let baseData = baseDataString.data(using: .utf8) else {
            XCTFail()
            return
        }
        let hexEncodedString = baseData.hexEncodedString()
        let expectedOutput = "<48656C6C6F20576F726C6421>"
        XCTAssertEqual(hexEncodedString, expectedOutput)
        
        let returnedData = Data(hexEncodedString: hexEncodedString)
        XCTAssertEqual(returnedData, baseData)
    }
}
