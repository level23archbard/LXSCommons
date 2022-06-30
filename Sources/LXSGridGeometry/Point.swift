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

// MARK: - Axis

public extension Point {
    
    /// The value of the point associated with the given axis.
    func value(of axis: Axis) -> Int {
        return self[axis]
    }
    
    subscript(axis: Axis) -> Int {
        get {
            switch axis {
            case .x: return x
            case .y: return y
            }
        }
        set {
            switch axis {
            case .x: x = newValue
            case .y: y = newValue
            }
        }
    }
}

// MARK: - Advancing

public extension Point {
    
    /// Gets the point offset from this point along the x axis by a specified amount.
    func advancedAlongX(by amount: Int) -> Point {
        return advanced(byX: amount, byY: 0)
    }
    
    /// Gets the point offset from this point along the y axis by a specified amount.
    func advancedAlongY(by amount: Int) -> Point {
        return advanced(byX: 0, byY: amount)
    }
    
    /// Gets the point offset from this point by the specified amounts on each respective axis.
    func advanced(byX xAmount: Int, byY yAmount: Int) -> Point {
        return Point(x: x + xAmount, y: y + yAmount)
    }
    
    /// Gets the point offset from this point along the given axis by a specified amount.
    func advanced(along axis: Axis, by amount: Int) -> Point {
        switch axis {
        case .x: return advancedAlongX(by: amount)
        case .y: return advancedAlongY(by: amount)
        }
    }
    
    /// Gets the next point offset from this point along the x axis.
    var nextAlongX: Point {
        return advancedAlongX(by: 1)
    }
    
    /// Gets the next point offset from this point along the y axis.
    var nextAlongY: Point {
        return advancedAlongY(by: 1)
    }
    
    /// Gets the previous point offset from this point along the x axis.
    var previousAlongX: Point {
        return advancedAlongX(by: -1)
    }
    
    /// Gets the previous point offset from this point along the y axis.
    var previousAlongY: Point {
        return advancedAlongY(by: -1)
    }
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
