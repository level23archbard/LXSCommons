//
//  Rect.swift
//  LXSCommons
//
//  Created by Alex Rote on 6/24/18.
//  Copyright © 2018 Alex Rote. All rights reserved.
//

import CoreGraphics

// MARK: - Rect

/// A grid rect represents the collection of points in a grid. The rect contains an origin point, and the size of the grid away from that origin. Note that if the rect's size is empty, then the rect's origin is not contained in the grid. The rect is enumerated by specifying a row by row sequence, or a column by column sequence.
public struct Rect: Hashable {
    
    /// The origin point of the rect. When enumerating through the rect, the origin is the first point.
    public var origin: Point
    /// The size of the rect. When enumerating through the rect, the size determines how many points are included.
    public var size: Size
    
    /// The width of the rect's size, or the number of unique columns in the rect.
    public var width: Int {
        get {
            return size.width
        }
        set {
            size.width = newValue
        }
    }
    
    /// The height of the rect's size, or the number of unique rows in the rect.
    public var height: Int {
        get {
            return size.height
        }
        set {
            size.height = newValue
        }
    }
    
    /// Creates a rect with an origin point and size.
    public init(origin: Point, size: Size) {
        self.origin = origin
        self.size = size
    }
    
    /// Creates a rect with x and y values of the origin point and width and height values of the size.
    public init(x: Int, y: Int, width: Int, height: Int) {
        self.init(origin: Point(x: x, y: y), size: Size(width: width, height: height))
    }
    
    /// The count of points in the rect.
    var count: Int {
        return size.area
    }
    
    /// Checks whether the rect is empty.
    var isEmpty: Bool {
        return size.isEmpty
    }
    
    /// Checks whether the point is contained within the rect.
    public func contains(point: Point) -> Bool {
        return !isEmpty && rangeX.contains(point.x) && rangeY.contains(point.y)
    }
}

// MARK: - Static Values

public extension Rect {
    
    /// The zero rect.
    static let zero = Rect(origin: .zero, size: .zero)
}

// MARK: - Standardized Rect

public extension Rect {
    
    /// A standardized rect that contains the same points of this rect. A standard rect has non-negative width and height values.
    var standardized: Rect {
        var newRect = self
        newRect.standardize()
        return newRect
    }
    
    /// Standardizes this rect. A standard rect has non-negative width and height values.
    mutating func standardize() {
        if width < 0 {
            width *= -1
            origin.x -= (width - 1)
        }
        if height < 0 {
            height *= -1
            origin.y -= (height - 1)
        }
    }
    
    /// The minimum X value or column of the rect. If the rect's size is not empty, a point with this value will be part of the rect's collection.
    var minX: Int {
        return standardized.origin.x
    }
    
    /// The minimum Y value or row of the rect. If the rect's size is not empty, a point with this value will be part of the rect's collection.
    var minY: Int {
        return standardized.origin.y
    }
    
    /// The maximum X value or column of the rect. If the rect's size is not empty, a point with this value will be part of the rect's collection.
    var maxX: Int {
        guard width != 0 else { return minX }
        let std = standardized
        return std.origin.x + std.width - 1
    }
    
    /// The maximum Y value or row of the rect. If the rect's size is not empty, a point with this value will be part of the rect's collection.
    var maxY: Int {
        guard height != 0 else { return minY }
        let std = standardized
        return std.origin.y + std.height - 1
    }
    
    /// The range of X values or columns of the rect. If the rect's size is not empty, a point with each of these values will be part of the rect's collection.
    var rangeX: CountableClosedRange<Int> {
        return minX...maxX
    }
    
    /// The range of Y values or columns of the rect. If the rect's size is not empty, a point with each of these values will be part of the rect's collection.
    var rangeY: CountableClosedRange<Int> {
        return minY...maxY
    }
    
    /// Creates a rect between the X range and Y range, including all points within the ranges.
    init(rangeX: CountableClosedRange<Int>, rangeY: CountableClosedRange<Int>) {
        self.init(origin: Point(x: rangeX.lowerBound, y: rangeY.lowerBound), size: Size(width: rangeX.count, height: rangeY.count))
    }
}

// MARK: - Equatable

extension Rect: Equatable {
    
    /// Two rects are equal if they contain the same points, meaning that their standardized rects are equal by values.
    public static func ==(left: Rect, right: Rect) -> Bool {
        let leftS = left.standardized, rightS = right.standardized
        return leftS.origin == rightS.origin && leftS.size == rightS.size
    }
}

// MARK: - Points Collection

public extension Rect {
    
    /// The sequence of points in the rect ordered row by row. All points will be iterated through a row, before proceeding to subsequent rows.
    struct RowByRowSequence: Sequence, IteratorProtocol {
        
        public typealias Element = Point
        
        private var i: Int, j: Int
        private let dI: Int, dJ: Int
        private let origin: Point
        private let bounds: Size
        
        fileprivate init(rect: Rect) {
            i = 0
            j = 0
            dI = rect.width < 0 ? -1 : 1
            dJ = rect.height < 0 ? -1 : 1
            origin = rect.origin
            bounds = rect.standardized.size
        }
        
        public mutating func next() -> Point? {
            guard j * dJ < bounds.height else { return nil }
            defer {
                i += dI
                if i * dI >= bounds.width { i = 0 }
                j += (i == 0) ? dJ : 0
            }
            return Point(x: origin.x + i, y: origin.y + j)
        }
    }
    
    /// The sequence of points in the rect ordered column by column. All points will be iterated through a column, before proceeding to subsequent columns.
    struct ColumnByColumnSequence: Sequence, IteratorProtocol {
        
        public typealias Element = Point
        
        private var i: Int, j: Int
        private let dI: Int, dJ: Int
        private let origin: Point
        private let bounds: Size
        
        fileprivate init(rect: Rect) {
            i = 0
            j = 0
            dI = rect.width < 0 ? -1 : 1
            dJ = rect.height < 0 ? -1 : 1
            origin = rect.origin
            bounds = rect.standardized.size
        }
        
        public mutating func next() -> Point? {
            guard i * dI < bounds.width else { return nil }
            defer {
                j += dJ
                if j * dJ >= bounds.height { j = 0 }
                i += (j == 0) ? dI : 0
            }
            return Point(x: origin.x + i, y: origin.y + j)
        }
    }
    
    /// The sequence of points in the rect ordered row by row. All points will be iterated through a row, before proceeding to subsequent rows.
    var rowByRow: RowByRowSequence {
        return RowByRowSequence(rect: self)
    }
    
    /// The sequence of points in the rect ordered column by column. All points will be iterated through a column, before proceeding to subsequent columns.
    var columnByColumn: ColumnByColumnSequence {
        return ColumnByColumnSequence(rect: self)
    }
}



// MARK: - Interoperability

public extension Rect {
    
    /// The CGRect representation of this rect.
    var cgRect: CGRect {
        return CGRect(origin: origin.cgPoint, size: size.cgSize)
    }
}

public extension CGRect {
    
    /// The grid rect representation of this rect.
    var gridRect: Rect {
        return Rect(origin: origin.gridPoint, size: size.gridSize)
    }
}
