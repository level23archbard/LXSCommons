//
//  Point.swift
//  LXSCommons
//
//  Created by Alex Rote on 6/24/18.
//  Copyright © 2018 Alex Rote. All rights reserved.
//

import CoreGraphics

// MARK: - Point

public struct Point: Equatable {
    
    public var x: Int
    public var y: Int
    
    public init(x: Int, y: Int) {
        self.x = x
        self.y = y
    }
}

// MARK: - Static Values

public extension Point {
    
    static let zero = Point(x: 0, y: 0)
}

// MARK: - Interoperability

public extension Point {
    
    var cgPoint: CGPoint {
        return CGPoint(x: x, y: y)
    }
}

public extension CGPoint {
    
    var gridPoint: Point {
        return Point(x: Int(x), y: Int(y))
    }
}
