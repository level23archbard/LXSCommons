//
//  Point.swift
//  LXSCommons
//
//  Created by Alex Rote on 6/24/18.
//  Copyright © 2018 Alex Rote. All rights reserved.
//

import CoreGraphics

// MARK: - Point

/// A grid point represents a discrete index on a grid. The point's x represents the column on the grid, and the point's y represents the row on the grid.
public struct Point: Hashable {
    
    /// The x index of the point, or the point's column in a grid.
    public var x: Int
    /// The y index of the point, or the point's row in a grid.
    public var y: Int
    
    /// Creates a point with x and y values.
    public init(x: Int, y: Int) {
        self.x = x
        self.y = y
    }
}

// MARK: - Static Values

public extension Point {
    
    /// The zero point.
    static let zero = Point(x: 0, y: 0)
}

// MARK: - Interoperability

public extension Point {
    
    /// The CGPoint representation of this point.
    var cgPoint: CGPoint {
        return CGPoint(x: x, y: y)
    }
}

public extension CGPoint {
    
    /// The grid point representation of this point.
    var gridPoint: Point {
        return Point(x: Int(x), y: Int(y))
    }
}
