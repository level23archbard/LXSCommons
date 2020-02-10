//
//  TestRandomness.swift
//  LXSCommons
//
//  Created by Alex Rote on 3/18/17.
//  Copyright © 2017 Alex Rote. All rights reserved.
//

import XCTest
@testable import LXSRandom

final class LXSRandomTests: XCTestCase {
    
    func testRandom() {
        print("The number is \(Random.Uniform.bool())!")
    }
    
    func testManyRandomBinary() {
        var headsCount = 0
        let rng = Random.Binary(p: 0.5)
        for _ in 0..<100000 {
            if rng.bool() {
                headsCount += 1
            }
        }
        print("The heads count is \(headsCount)!")
    }
}
