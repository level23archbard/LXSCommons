//
//  Rect.swift
//  LXSCommons
//
//  Created by Alex Rote on 6/24/18.
//  Copyright © 2018 Alex Rote. All rights reserved.
//

import CoreGraphics

// MARK: - Rect

public struct Rect {
    
    public var origin: Point
    public var size: Size
    
    public var width: Int {
        get {
            return size.width
        }
        set {
            size.width = newValue
        }
    }
    
    public var height: Int {
        get {
            return size.height
        }
        set {
            size.height = newValue
        }
    }
    
    public init(origin: Point, size: Size) {
        self.origin = origin
        self.size = size
    }
    
    public init(x: Int, y: Int, width: Int, height: Int) {
        self.init(origin: Point(x: x, y: y), size: Size(width: width, height: height))
    }
}

// MARK: - Static Values

public extension Rect {
    
    static let zero = Rect(origin: .zero, size: .zero)
}

// MARK: - Standardized Rect

public extension Rect {
    
    var standardized: Rect {
        var newRect = self
        newRect.standardize()
        return newRect
    }
    
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
    
    var minX: Int {
        return standardized.origin.x
    }
    
    var minY: Int {
        return standardized.origin.y
    }
    
    var maxX: Int {
        guard width != 0 else { return minX }
        let std = standardized
        return std.origin.x + std.width - 1
    }
    
    var maxY: Int {
        guard height != 0 else { return minY }
        let std = standardized
        return std.origin.y + std.height - 1
    }
    
    init(rangeX: CountableClosedRange<Int>, rangeY: CountableClosedRange<Int>) {
        self.init(origin: Point(x: rangeX.lowerBound, y: rangeY.lowerBound), size: Size(width: rangeX.count, height: rangeY.count))
    }
}

// MARK: - Equatable

extension Rect: Equatable {
    
    public static func ==(left: Rect, right: Rect) -> Bool {
        let leftS = left.standardized, rightS = right.standardized
        return leftS.origin == rightS.origin && leftS.size == rightS.size
    }
}

// MARK: - Points Collection

public extension Rect {
    
    struct RowByRowSequence: Sequence, IteratorProtocol {
        
        public typealias Element = Point
        
        private var i: Int, j: Int
        private let dI: Int, dJ: Int
        private let origin: Point
        private let bounds: Size
        
        init(rect: Rect) {
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
    
    struct ColumnByColumnSequence: Sequence, IteratorProtocol {
        
        public typealias Element = Point
        
        private var i: Int, j: Int
        private let dI: Int, dJ: Int
        private let origin: Point
        private let bounds: Size
        
        init(rect: Rect) {
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
    
    var rowByRow: RowByRowSequence {
        return RowByRowSequence(rect: self)
    }
    
    var columnByColumn: ColumnByColumnSequence {
        return ColumnByColumnSequence(rect: self)
    }
}



// MARK: - Interoperability

public extension Rect {
    
    var cgRect: CGRect {
        return CGRect(origin: origin.cgPoint, size: size.cgSize)
    }
}
