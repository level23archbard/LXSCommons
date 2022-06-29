//
//  Size.swift
//  LXSCommons
//
//  Created by Alex Rote on 6/24/18.
//  Copyright © 2018 Alex Rote. All rights reserved.
//

import CoreGraphics

// MARK: - Size

/// A grid size represents the dimensions of a grid. The size's width represents the number of unique columns in a grid, and the size's height represents the number of unique rows in a grid.
public struct Size: Hashable {
    
    /// The width of the size, or the size's number of unique columns in a grid.
    public var width: Int
    /// The height of the size, or the size's number of unique rows in a grid.
    public var height: Int
    
    /// Creates a size with width and height values.
    public init(width: Int, height: Int) {
        self.width = width
        self.height = height
    }
}

// MARK: - Static Values

public extension Size {
    
    /// The zero size.
    static let zero = Size(width: 0, height: 0)
}

// MARK: - Area

public extension Size {
    
    /// The area of the size, or the size's number of unique points that could be contained in a grid.
    var area: Int {
        return width * height
    }
    
    /// Checks whether the size is empty, meaning a grid of this size does not contain any points.
    var isEmpty: Bool {
        return width == 0 || height == 0
    }
}

// MARK: - Bounds

public extension Size {
    
    /// The bounds of the size, or a rect with its origin point as zero.
    var bounds: Rect {
        return Rect(origin: .zero, size: self)
    }
}

// MARK: - Square

public extension Size {
    
    /// Creates a square size with equal width and height values.
    init(square length: Int) {
        self.init(width: length, height: length)
    }
    
    /// Checks whether the size represents a square, meaning a grid of this size has equal width and height.
    var isSquare: Bool {
        return width == height
    }
}

// MARK: - Interoperability

public extension Size {
    
    /// The CGSize representation of this size.
    var cgSize: CGSize {
        return CGSize(width: width, height: height)
    }
}

public extension CGSize {
    
    /// The grid size representation of this size.
    var gridSize: Size {
        return Size(width: Int(width), height: Int(height))
    }
}
