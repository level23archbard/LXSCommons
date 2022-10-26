//
//  TestCoding.swift
//  LXSCommons
//
//  Created by Alex Rote on 11/13/21.
//

import XCTest
@testable import LXSJson

final class LXSJsonTestCoding: XCTestCase {
    
    // Helper to save some space
    func typeOf(_ json: JSON) -> String {
        JSON.typeOf(json).rawValue
    }
    
    func testEncoderBasics() throws {
        struct Test: Encodable {
            let a: Int
            let b: String
            let c: String?
        }
        let test = Test(a: 42, b: "hello", c: nil)
        
        let j = try JSON.Encoder().encode(test)
        XCTAssertEqual(typeOf(j.a), "number")
        XCTAssertEqual(JSON.doubleValue(j.a), 42)
        XCTAssertEqual(typeOf(j.b), "string")
        XCTAssertEqual(JSON.stringValue(j.b), "hello")
        XCTAssertEqual(typeOf(j.c), "null")
        
        struct ComplexTest: Encodable {
            let id: Int
            let inner: Test?
            let another: Test?
        }
        let test2 = ComplexTest(id: 0, inner: test, another: nil)
        let j2 = try JSON.Encoder().encode(test2)
        XCTAssertEqual(typeOf(j2.id), "number")
        XCTAssertEqual(JSON.doubleValue(j2.id), 0)
        XCTAssertEqual(typeOf(j2.inner.a), "number")
        XCTAssertEqual(JSON.doubleValue(j2.inner.a), 42)
        XCTAssertEqual(typeOf(j2.inner.b), "string")
        XCTAssertEqual(JSON.stringValue(j2.inner.b), "hello")
        XCTAssertEqual(typeOf(j2.inner.c), "null")
        XCTAssertEqual(typeOf(j2.another), "null")
        
        struct MoreComplexTest: Encodable {
            let count: Int
            var items: [ComplexTest]
        }
        let test3 = MoreComplexTest(count: 3, items: [test2, test2, test2])
        let j3 = try JSON.Encoder().encode(test3)
        XCTAssertEqual(typeOf(j3.count), "number")
        XCTAssertEqual(JSON.doubleValue(j3.count), 3)
        XCTAssertEqual(typeOf(j3.items[0].id), "number")
        XCTAssertEqual(JSON.doubleValue(j3.items[0].id), 0)
        XCTAssertEqual(typeOf(j3.items[0].inner.a), "number")
        XCTAssertEqual(JSON.doubleValue(j3.items[0].inner.a), 42)
        XCTAssertEqual(typeOf(j3.items[0].inner.b), "string")
        XCTAssertEqual(JSON.stringValue(j3.items[0].inner.b), "hello")
        XCTAssertEqual(typeOf(j3.items[0].inner.c), "null")
        XCTAssertEqual(typeOf(j3.items[0].another), "null")
        XCTAssertEqual(typeOf(j3.items[1].id), "number")
        XCTAssertEqual(JSON.doubleValue(j3.items[1].id), 0)
        XCTAssertEqual(typeOf(j3.items[1].inner.a), "number")
        XCTAssertEqual(JSON.doubleValue(j3.items[1].inner.a), 42)
        XCTAssertEqual(typeOf(j3.items[1].inner.b), "string")
        XCTAssertEqual(JSON.stringValue(j3.items[1].inner.b), "hello")
        XCTAssertEqual(typeOf(j3.items[1].inner.c), "null")
        XCTAssertEqual(typeOf(j3.items[1].another), "null")
        XCTAssertEqual(typeOf(j3.items[2].id), "number")
        XCTAssertEqual(JSON.doubleValue(j3.items[2].id), 0)
        XCTAssertEqual(typeOf(j3.items[2].inner.a), "number")
        XCTAssertEqual(JSON.doubleValue(j3.items[2].inner.a), 42)
        XCTAssertEqual(typeOf(j3.items[2].inner.b), "string")
        XCTAssertEqual(JSON.stringValue(j3.items[2].inner.b), "hello")
        XCTAssertEqual(typeOf(j3.items[2].inner.c), "null")
        XCTAssertEqual(typeOf(j3.items[2].another), "null")
    }
    
    func testDecoderBasics() throws {
        var j: JSON = [:]
        j.one = 1
        j.two = "two"
        j.three = [1, 2, 3, 4]
        j.four = [:]
        j.four.x = .null
        j.four.y = 42
        
        struct TestInner: Decodable, Equatable {
            let x: Int?
            let y: Int?
        }
        struct TestOuter: Decodable, Equatable {
            let one: String
            let two: String
            let three: [Int]
            let four: TestInner
        }
        let test = try JSON.Decoder().decode(TestOuter.self, from: j)
        XCTAssertEqual(test, TestOuter(one: "1", two: "two", three: [1, 2, 3, 4], four: TestInner(x: nil, y: 42)))
        
        j.two = .undefined
        var decoder = JSON.Decoder()
        decoder.options.stringParsingOptions.undefinedParsing = .asEmpty
        let test2 = try decoder.decode(TestOuter.self, from: j)
        XCTAssertEqual(test2, TestOuter(one: "1", two: "", three: [1, 2, 3, 4], four: TestInner(x: nil, y: 42)))
    }
}
