//
//  Size.swift
//  LXSCommons
//
//  Created by Alex Rote on 6/24/18.
//  Copyright © 2018 Alex Rote. All rights reserved.
//

import CoreGraphics

// MARK: - Size

public struct Size: Equatable {
    
    public var width: Int
    public var height: Int
    
    public init(width: Int, height: Int) {
        self.width = width
        self.height = height
    }
}

// MARK: - Static Values

public extension Size {
    
    static let zero = Size(width: 0, height: 0)
}

// MARK: - Area

public extension Size {
    
    var area: Int {
        return width * height
    }
}

// MARK: - Bounds

public extension Size {
    
    var bounds: Rect {
        return Rect(origin: .zero, size: self)
    }
}

// MARK: - Interoperability

public extension Size {
    
    var cgSize: CGSize {
        return CGSize(width: width, height: height)
    }
}

public extension CGSize {
    
    var gridSize: Size {
        return Size(width: Int(width), height: Int(height))
    }
}
