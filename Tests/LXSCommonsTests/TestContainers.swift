//
//  TestContainers.swift
//  LXSCommons
//
//  Created by Alex Rote on 3/1/20.
//

import XCTest
@testable import LXSCommons

class TestContainers: XCTestCase {
    
    struct TestStruct {
        var name: String
        var age: Int
        var title: String {
            "tester"
        }
    }
    
    class TestMailbox {
        var counter = 0
    }
    
    func testBasics() {
        let test = Container(TestStruct(name: "Bob", age: 42))
        let p1 = test.property(\.name)
        XCTAssertEqual(p1.value, "Bob")
        
        let p2 = test.mutableProperty(\.age)
        let p3 = test.property(\.age)
        XCTAssertEqual(p2.value, 42)
        XCTAssertEqual(p3.value, 42)
        p2.value = 43
        XCTAssertEqual(p2.value, 43)
        XCTAssertEqual(p3.value, 43)
        
        let p4 = test.property(\.title)
        XCTAssertEqual(p4.value, "tester")
        
        let mailbox = TestMailbox()
        XCTAssertEqual(mailbox.counter, 0)
        
        let o1 = test.observe(property: p3) {
            mailbox.counter += p3.value
        }
        XCTAssertEqual(mailbox.counter, 0)
        p2.value = 1
        XCTAssertEqual(p3.value, 1)
        XCTAssertEqual(mailbox.counter, 1)
        test.removeObserver(o1)
        p2.value = 2
        XCTAssertEqual(p3.value, 2)
        XCTAssertEqual(mailbox.counter, 1)
    }
}
