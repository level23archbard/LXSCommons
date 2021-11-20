//
//  TestBasics.swift
//  LXSCommons
//
//  Created by Alex Rote on 11/10/21.
//

import XCTest
@testable import LXSJson

final class LXSJsonTestBasics: XCTestCase {
    
    // Helper to save some space
    func typeOf(_ json: JSON) -> String {
        JSON.typeOf(json).rawValue
    }
    
    func testBasicInit() {
        let j = JSON()
        XCTAssertEqual(JSON.stringify(j), "undefined")
    }
    
    func testNilInit() {
        let j: JSON = nil
        XCTAssertEqual(JSON.stringify(j), "null")
    }
    
    func testBooleanInit() {
        var j: JSON
        
        j = true
        XCTAssertEqual(JSON.stringify(j), "true")
        j = false
        XCTAssertEqual(JSON.stringify(j), "false")
    }
    
    func testNumberInit() {
        var j: JSON
        
        j = 4
        XCTAssertEqual(JSON.stringify(j), "4")
        j = 4.0
        XCTAssertEqual(JSON.stringify(j), "4")
        j = 4.2
        XCTAssert(JSON.stringify(j).starts(with: "4.2")) // Do a startsWith check, since string-double representation goes on for a while...
    }
    
    func testStringInit() {
        let j: JSON = "hello"
        XCTAssertEqual(JSON.stringify(j), "\"hello\"")
    }
    
    func testArrayInit() {
        let j: JSON = [true, false, nil, .undefined, 42, "42"]
        XCTAssertEqual(JSON.stringify(j), "[true,false,null,42,\"42\"]")
    }
    
    func testObjectInit() {
        let j: JSON = [
            "a": true,
            "b": false,
            "c": nil,
            "d": .undefined,
            "e": 42,
            "a": "42"
        ]
        let test = JSON.stringify(j)
        // Let's not test objects by exact ordering for now, instead just check the relative structure is roughly right.
        XCTAssert(test.starts(with: "{"))
        XCTAssert(test.contains("\"a\":\"42\""))
        XCTAssert(test.contains("\"b\":false"))
        XCTAssert(test.contains("\"c\":null"))
        XCTAssertFalse(test.contains("\"d\":"))
        XCTAssert(test.contains("\"e\":42"))
        XCTAssertEqual(test.components(separatedBy: ",").count, 4)
        XCTAssert(test.hasSuffix("}"))
    }
    
    func testStaticUndefined() {
        let j = JSON.undefined
        XCTAssertEqual(JSON.stringify(j), "undefined")
    }
    
    func testStaticNull() {
        let j = JSON.null
        XCTAssertEqual(JSON.stringify(j), "null")
    }
    
    func testStaticBoolean() {
        var j: JSON
        
        j = .true
        XCTAssertEqual(JSON.stringify(j), "true")
        j = .false
        XCTAssertEqual(JSON.stringify(j), "false")
    }
    
    func testDelete() {
        var j = JSON.null
        JSON.delete(data: &j)
        XCTAssertEqual(JSON.stringify(j), "undefined")
        XCTAssertEqual(JSON.stringify(.null), "null")
    }
    
    func testParsingUndefined() throws {
        let test = "undefined"
        let j = try JSON.parse(test)
        XCTAssertEqual(JSON.stringify(j), "undefined")
    }
    
    func testParsingNull() throws {
        let test = "null"
        let j = try JSON.parse(test)
        XCTAssertEqual(JSON.stringify(j), "null")
    }
    
    func testParsingBoolean() throws {
        var test: String
        var j: JSON
        
        test = "true"
        j = try JSON.parse(test)
        XCTAssertEqual(JSON.stringify(j), "true")
        test = "false"
        j = try JSON.parse(test)
        XCTAssertEqual(JSON.stringify(j), "false")
    }
    
    func testParsingNumber() throws {
        let test = "42"
        let j = try JSON.parse(test)
        XCTAssertEqual(JSON.stringify(j), "42")
    }
    
    func testParsingString() throws {
        let test = "\"hello\""
        let j = try JSON.parse(test)
        XCTAssertEqual(JSON.stringify(j), "\"hello\"")
    }
    
    func testParsingArray() throws {
        let test = "[1,2,3]"
        let j = try JSON.parse(test)
        XCTAssertEqual(JSON.stringify(j), "[1,2,3]")
    }
    
    func testParsingObject() throws {
        let test = "{\"a\":42}"
        let j = try JSON.parse(test)
        XCTAssertEqual(JSON.stringify(j), "{\"a\":42}")
    }
    
    func testTypes() {
        let undefined = JSON.undefined
        XCTAssertEqual(typeOf(undefined), "undefined")
        let null = JSON.null
        XCTAssertEqual(typeOf(null), "null")
        let bTrue = JSON.true
        XCTAssertEqual(typeOf(bTrue), "boolean")
        let bFalse = JSON.false
        XCTAssertEqual(typeOf(bFalse), "boolean")
        let number: JSON = 42
        XCTAssertEqual(typeOf(number), "number")
        let string: JSON = "42"
        XCTAssertEqual(typeOf(string), "string")
        let array: JSON = ["42"]
        XCTAssertEqual(typeOf(array), "array")
        let object: JSON = ["42": number]
        XCTAssertEqual(typeOf(object), "object")
        
        // Apologies for the mess here...
        XCTAssertTrue(JSON.isTruthy(JSON.instanceOf(undefined, type: .undefined)))
        XCTAssertFalse(JSON.isTruthy(JSON.instanceOf(undefined, type: .null)))
        XCTAssertFalse(JSON.isTruthy(JSON.instanceOf(undefined, type: .boolean)))
        XCTAssertFalse(JSON.isTruthy(JSON.instanceOf(undefined, type: .number)))
        XCTAssertFalse(JSON.isTruthy(JSON.instanceOf(undefined, type: .string)))
        XCTAssertFalse(JSON.isTruthy(JSON.instanceOf(undefined, type: .array)))
        XCTAssertFalse(JSON.isTruthy(JSON.instanceOf(undefined, type: .object)))
        XCTAssertFalse(JSON.isTruthy(JSON.instanceOf(null, type: .undefined)))
        XCTAssertTrue(JSON.isTruthy(JSON.instanceOf(null, type: .null)))
        XCTAssertFalse(JSON.isTruthy(JSON.instanceOf(null, type: .boolean)))
        XCTAssertFalse(JSON.isTruthy(JSON.instanceOf(null, type: .number)))
        XCTAssertFalse(JSON.isTruthy(JSON.instanceOf(null, type: .string)))
        XCTAssertFalse(JSON.isTruthy(JSON.instanceOf(null, type: .array)))
        XCTAssertFalse(JSON.isTruthy(JSON.instanceOf(null, type: .object)))
        XCTAssertFalse(JSON.isTruthy(JSON.instanceOf(bFalse, type: .undefined)))
        XCTAssertFalse(JSON.isTruthy(JSON.instanceOf(bFalse, type: .null)))
        XCTAssertTrue(JSON.isTruthy(JSON.instanceOf(bFalse, type: .boolean)))
        XCTAssertFalse(JSON.isTruthy(JSON.instanceOf(bFalse, type: .number)))
        XCTAssertFalse(JSON.isTruthy(JSON.instanceOf(bFalse, type: .string)))
        XCTAssertFalse(JSON.isTruthy(JSON.instanceOf(bFalse, type: .array)))
        XCTAssertFalse(JSON.isTruthy(JSON.instanceOf(bFalse, type: .object)))
        XCTAssertFalse(JSON.isTruthy(JSON.instanceOf(number, type: .undefined)))
        XCTAssertFalse(JSON.isTruthy(JSON.instanceOf(number, type: .null)))
        XCTAssertFalse(JSON.isTruthy(JSON.instanceOf(number, type: .boolean)))
        XCTAssertTrue(JSON.isTruthy(JSON.instanceOf(number, type: .number)))
        XCTAssertFalse(JSON.isTruthy(JSON.instanceOf(number, type: .string)))
        XCTAssertFalse(JSON.isTruthy(JSON.instanceOf(number, type: .array)))
        XCTAssertFalse(JSON.isTruthy(JSON.instanceOf(number, type: .object)))
        XCTAssertFalse(JSON.isTruthy(JSON.instanceOf(string, type: .undefined)))
        XCTAssertFalse(JSON.isTruthy(JSON.instanceOf(string, type: .null)))
        XCTAssertFalse(JSON.isTruthy(JSON.instanceOf(string, type: .boolean)))
        XCTAssertFalse(JSON.isTruthy(JSON.instanceOf(string, type: .number)))
        XCTAssertTrue(JSON.isTruthy(JSON.instanceOf(string, type: .string)))
        XCTAssertFalse(JSON.isTruthy(JSON.instanceOf(string, type: .array)))
        XCTAssertFalse(JSON.isTruthy(JSON.instanceOf(string, type: .object)))
        XCTAssertFalse(JSON.isTruthy(JSON.instanceOf(array, type: .undefined)))
        XCTAssertFalse(JSON.isTruthy(JSON.instanceOf(array, type: .null)))
        XCTAssertFalse(JSON.isTruthy(JSON.instanceOf(array, type: .boolean)))
        XCTAssertFalse(JSON.isTruthy(JSON.instanceOf(array, type: .number)))
        XCTAssertFalse(JSON.isTruthy(JSON.instanceOf(array, type: .string)))
        XCTAssertTrue(JSON.isTruthy(JSON.instanceOf(array, type: .array)))
        XCTAssertFalse(JSON.isTruthy(JSON.instanceOf(array, type: .object)))
        XCTAssertFalse(JSON.isTruthy(JSON.instanceOf(object, type: .undefined)))
        XCTAssertFalse(JSON.isTruthy(JSON.instanceOf(object, type: .null)))
        XCTAssertFalse(JSON.isTruthy(JSON.instanceOf(object, type: .boolean)))
        XCTAssertFalse(JSON.isTruthy(JSON.instanceOf(object, type: .number)))
        XCTAssertFalse(JSON.isTruthy(JSON.instanceOf(object, type: .string)))
        XCTAssertFalse(JSON.isTruthy(JSON.instanceOf(object, type: .array)))
        XCTAssertTrue(JSON.isTruthy(JSON.instanceOf(object, type: .object)))
    }
    
    func testIsTruthy() {
        XCTAssertFalse(JSON.isTruthy(.false))
        XCTAssertTrue(JSON.isTruthy(.true))
        XCTAssertFalse(JSON.isTruthy(0))
        XCTAssertTrue(JSON.isTruthy(1))
        XCTAssertTrue(JSON.isTruthy(4.2))
        XCTAssertTrue(JSON.isTruthy("0"))
        XCTAssertTrue(JSON.isTruthy("000"))
        XCTAssertTrue(JSON.isTruthy("1"))
        XCTAssertFalse(JSON.isTruthy(""))
        XCTAssertTrue(JSON.isTruthy("20"))
        XCTAssertTrue(JSON.isTruthy("twenty"))
        XCTAssertTrue(JSON.isTruthy([]))
        XCTAssertTrue(JSON.isTruthy([20]))
        XCTAssertTrue(JSON.isTruthy([10, 20]))
        XCTAssertTrue(JSON.isTruthy(["twenty"]))
        XCTAssertTrue(JSON.isTruthy(["ten", "twenty"]))
        XCTAssertTrue(JSON.isTruthy([:]))
        XCTAssertFalse(JSON.isTruthy(.null))
        XCTAssertFalse(JSON.isTruthy(.undefined))
    }
    
    func testDoubleValue() {
        XCTAssertEqual(JSON.doubleValue(.false), 0)
        XCTAssertEqual(JSON.doubleValue(.true), 1)
        XCTAssertEqual(JSON.doubleValue(0), 0)
        XCTAssertEqual(JSON.doubleValue(1), 1)
        XCTAssertEqual(JSON.doubleValue(4.2), 4.2)
        XCTAssertEqual(JSON.doubleValue("0"), 0)
        XCTAssertEqual(JSON.doubleValue("000"), 0)
        XCTAssertEqual(JSON.doubleValue("1"), 1)
        XCTAssertEqual(JSON.doubleValue(""), 0)
        XCTAssertEqual(JSON.doubleValue("20"), 20)
        XCTAssertEqual(JSON.doubleValue("twenty"), nil)
        XCTAssertEqual(JSON.doubleValue([]), 0)
        XCTAssertEqual(JSON.doubleValue([20]), 20)
        XCTAssertEqual(JSON.doubleValue([10, 20]), nil)
        XCTAssertEqual(JSON.doubleValue(["twenty"]), nil)
        XCTAssertEqual(JSON.doubleValue(["ten", "twenty"]), nil)
        XCTAssertEqual(JSON.doubleValue([:]), nil)
        XCTAssertEqual(JSON.doubleValue(.null), 0)
        XCTAssertEqual(JSON.doubleValue(.undefined), nil)
    }
    
    func testStringValue() {
        XCTAssertEqual(JSON.stringValue(.false), "false")
        XCTAssertEqual(JSON.stringValue(.true), "true")
        XCTAssertEqual(JSON.stringValue(0), "0")
        XCTAssertEqual(JSON.stringValue(1), "1")
        XCTAssertEqual(JSON.stringValue(4.2), "4.2")
        XCTAssertEqual(JSON.stringValue("0"), "0")
        XCTAssertEqual(JSON.stringValue("000"), "000")
        XCTAssertEqual(JSON.stringValue("1"), "1")
        XCTAssertEqual(JSON.stringValue(""), "")
        XCTAssertEqual(JSON.stringValue("20"), "20")
        XCTAssertEqual(JSON.stringValue("twenty"), "twenty")
        XCTAssertEqual(JSON.stringValue([]), "")
        XCTAssertEqual(JSON.stringValue([20]), "20")
        XCTAssertEqual(JSON.stringValue([10, 20]), "10,20")
        XCTAssertEqual(JSON.stringValue(["twenty"]), "twenty")
        XCTAssertEqual(JSON.stringValue(["ten", "twenty"]), "ten,twenty")
        XCTAssertEqual(JSON.stringValue([:]), "[object Object]")
        XCTAssertEqual(JSON.stringValue(.null), "null")
        XCTAssertEqual(JSON.stringValue(.undefined), "undefined")
    }
    
    func testConversions() {
        XCTAssertEqual(typeOf(JSON.toBoolean(42)), "boolean")
        XCTAssertEqual(typeOf(JSON.toNumber("42")), "number")
        XCTAssertEqual(typeOf(JSON.toNumber([42, 4.2])), "undefined")
        XCTAssertEqual(typeOf(JSON.toString(42)), "string")
    }
    
    func testPropertyBasics() {
        var obj: JSON = ["a": 42, "b": 4.2, "c": "42"]
        XCTAssertEqual(typeOf(obj.a), "number")
        XCTAssertEqual(JSON.doubleValue(obj.a), 42)
        XCTAssertEqual(typeOf(obj.b), "number")
        XCTAssertEqual(JSON.doubleValue(obj.b), 4.2)
        XCTAssertEqual(typeOf(obj.c), "string")
        XCTAssertEqual(JSON.stringValue(obj.c), "42")
        obj.a = "4.2"
        XCTAssertEqual(typeOf(obj.a), "string")
        XCTAssertEqual(JSON.stringValue(obj.a), "4.2")
        XCTAssertEqual(typeOf(obj.d), "undefined")
        obj.d = true
        XCTAssertEqual(typeOf(obj.d), "boolean")
        XCTAssertEqual(JSON.isTruthy(obj.d), true)
        XCTAssertTrue(JSON.isTruthy(JSON.hasOwnProperty(obj, property: "a")))
        XCTAssertTrue(JSON.isTruthy(JSON.hasOwnProperty(obj, property: "b")))
        XCTAssertTrue(JSON.isTruthy(JSON.hasOwnProperty(obj, property: "c")))
        XCTAssertTrue(JSON.isTruthy(JSON.hasOwnProperty(obj, property: "d")))
        XCTAssertFalse(JSON.isTruthy(JSON.hasOwnProperty(obj, property: "e")))
        
        var arr: JSON = ["a", "b", "c"]
        XCTAssertEqual(typeOf(arr[0]), "string")
        XCTAssertEqual(JSON.stringValue(arr[0]), "a")
        XCTAssertEqual(typeOf(arr[1]), "string")
        XCTAssertEqual(JSON.stringValue(arr[1]), "b")
        XCTAssertEqual(typeOf(arr[2]), "string")
        XCTAssertEqual(JSON.stringValue(arr[2]), "c")
        XCTAssertEqual(typeOf(arr[3]), "undefined")
        arr[3] = 42
        XCTAssertEqual(typeOf(arr[3]), "number")
        XCTAssertEqual(JSON.doubleValue(arr[3]), 42)
        arr[1] = .null
        XCTAssertEqual(typeOf(arr[1]), "null")
        XCTAssertEqual(JSON.stringValue(arr["0"]), "a")
        XCTAssertEqual(typeOf(arr["1"]), "null")
        XCTAssertEqual(JSON.stringValue(arr[2]), "c")
        XCTAssertEqual(JSON.doubleValue(arr[3]), 42)
        
        XCTAssertEqual(typeOf(JSON(value: 42).test), "undefined")
    }
}
