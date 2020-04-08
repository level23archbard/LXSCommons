//
//  TestStaticCodable.swift
//  LXSCommons
//
//  Created by Alex Rote on 2/25/20.
//

import XCTest
@testable import LXSCommons

struct PoorlyFormedYetValidStaticCodable: StaticCodable {
    
    static var allCases: [PoorlyFormedYetValidStaticCodable] {
        [
            PoorlyFormedYetValidStaticCodable(id: "test", name: "Name1"),
            PoorlyFormedYetValidStaticCodable(id: "test", name: "Name2"),
        ]
    }
    
    let id: String
    let name: String
    
    private init(id: String, name: String) {
        self.id = id
        self.name = name
    }
}

struct Wrapper: Codable {
    var value: PoorlyFormedYetValidStaticCodable
}

class TestStaticCodable: XCTestCase {
    
    func testCoding() {
        let test = Wrapper(value: PoorlyFormedYetValidStaticCodable.allCases.last!)
        XCTAssertEqual(test.value.id, "test")
        XCTAssertEqual(test.value.name, "Name2")
        let data = try? JSONEncoder().encode(test)
        XCTAssertNotNil(data)
        guard let unwrappedData = data else {
            return
        }
        let result = try? JSONDecoder().decode(Wrapper.self, from: unwrappedData)
        XCTAssertNotNil(result)
        guard let unwrappedResult = result else {
            return
        }
        XCTAssertEqual(unwrappedResult.value.id, "test")
        XCTAssertEqual(unwrappedResult.value.name, "Name1")
    }
    
    func testCodingIntrospection() {
        let test = Wrapper(value: PoorlyFormedYetValidStaticCodable.allCases.last!)
        XCTAssertEqual(test.value.id, "test")
        XCTAssertEqual(test.value.name, "Name2")
        let data = try? JSONEncoder().encode(test)
        XCTAssertNotNil(data)
        XCTAssertEqual(data, "{\"value\":\"test\"}".data(using: .utf8))
    }
    
    func testEquality() {
        let first = PoorlyFormedYetValidStaticCodable.allCases.first!
        let last = PoorlyFormedYetValidStaticCodable.allCases.last!
        XCTAssertEqual(first, last)
        XCTAssertEqual(first.hashValue, last.hashValue)
        XCTAssertNotEqual(first.name, last.name)
    }
}
