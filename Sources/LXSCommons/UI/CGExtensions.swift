//
//  CGExtensions.swift
//  LXSCommons
//
//  Created by Alex Rote on 1/31/15.
//  Copyright (c) 2015 Alex Rote. All rights reserved.
//

import CoreGraphics

// Extensions Relating to CoreGraphics classes
// CGPoint
// CGVector
// CGSize
// CGRect

public extension CGPoint {
    
    var vector: CGVector {
        return CGVector(dx: x, dy: y)
    }
    
    var gridPoint: Point {
        return Point(x: Int(x), y: Int(y))
    }
    
    static func + (left: CGPoint, right: CGVector) -> CGPoint {
        return CGPoint(x: left.x + right.dx, y: left.y + right.dy)
    }
    
    static func + (left: CGVector, right: CGPoint) -> CGPoint {
        return right + left
    }
    
    static func += (left: inout CGPoint, right: CGVector) {
        left = left + right
    }
    
    func bounded(by bounds: CGRect) -> CGPoint {
        return CGPoint(x: x.bounded(by: bounds.minX...bounds.maxX), y: y.bounded(by: bounds.minY...bounds.maxY))
    }
}

public extension CGVector {
    
    static let right = CGVector(dx: 1, dy: 0)
    static let left = CGVector(dx: -1, dy: 0)
    static let up = CGVector(dx: 0, dy: 1)
    static let down = CGVector(dx: 0, dy: -1)
    
    var magnitude: CGFloat {
        get {
            return sqrt((dx * dx) + (dy * dy))
        }
        set(newMagnitude) {
            let sameDirection = direction
            dx = sameDirection.dx * newMagnitude
            dy = sameDirection.dy * newMagnitude
        }
    }
    
    var direction: CGVector {
        get {
            let tempMag = magnitude
            if tempMag == 0 {
                return .zero
            } else {
                return CGVector(dx: dx / tempMag, dy: dy / tempMag)
            }
        }
        set(newDirection) {
            let newDirectionsLength = newDirection.magnitude
            var newUnitDirectionDX, newUnitDirectionDY: CGFloat
            if newDirectionsLength == 0 {
                newUnitDirectionDX = 0
                newUnitDirectionDY = 0
            } else {
                newUnitDirectionDX = newDirection.dx / newDirectionsLength
                newUnitDirectionDY = newDirection.dy / newDirectionsLength
            }
            let sameMagnitude = magnitude
            dx = newUnitDirectionDX * sameMagnitude
            dy = newUnitDirectionDY * sameMagnitude
        }
    }
    
    var point: CGPoint {
        return CGPoint(x: dx, y: dy)
    }
    
    init(from: CGPoint, to: CGPoint) {
        self.init(dx: to.x - from.x, dy: to.y - from.y)
    }
    
    init(magnitude: CGFloat, direction: CGVector) {
        let directionsLength = direction.magnitude
        let unitDirection: CGVector
        if directionsLength == 0 {
            unitDirection = CGVector(dx: 0.0, dy: 0.0)
        } else {
            unitDirection = CGVector(dx: direction.dx / directionsLength, dy: direction.dy / directionsLength)
        }
        self.init(dx: unitDirection.dx * magnitude, dy: unitDirection.dy * magnitude)
    }
    
    init(magnitude: CGFloat, rotation radians: CGFloat) {
        self.init(dx: cos(radians) * magnitude, dy: sin(radians) * magnitude)
    }
    
    static func + (left: CGVector, right: CGVector) -> CGVector {
        return CGVector(dx: left.dx + right.dx, dy: left.dy + right.dy)
    }
    
    static func - (left: CGVector, right: CGVector) -> CGVector {
        return CGVector(dx: left.dx - right.dx, dy: left.dy - right.dy)
    }
    
    static func * (left: CGFloat, right: CGVector) -> CGVector {
        return CGVector(dx: left * right.dx, dy: left * right.dy)
    }
    
    static func * (left: CGVector, right: CGFloat) -> CGVector {
        return right * left
    }
    
    static func / (left: CGVector, right: CGFloat) -> CGVector {
        return CGVector(dx: left.dx / right, dy: left.dy / right)
    }
    
    static func += (left: inout CGVector, right: CGVector) {
        left = left + right
    }
    
    static func *= (left: inout CGVector, right: CGFloat) {
        left = left * right
    }
}

public extension CGSize {
    
    var area: CGFloat {
        return width * height
    }
    
    var gridSize: Size {
        return Size(width: Int(width), height: Int(height))
    }
}

public extension CGRect {
    
    var center: CGPoint {
        get {
            return CGPoint(x: midX, y: midY)
        }
        set(newCenter) {
            self.origin = CGPoint(x: newCenter.x - (width / CGFloat(2.0)), y: newCenter.y - (width / CGFloat(2.0)))
        }
    }
    
    init(center: CGPoint, size: CGSize) {
        self.init(origin: CGPoint(x: center.x - size.width / CGFloat(2.0), y: center.y - size.height / CGFloat(2.0)), size: size)
    }
    
    init(minX: CGFloat, minY: CGFloat, maxX: CGFloat, maxY: CGFloat) {
        self.init(origin: CGPoint(x: minX, y: minY), size: CGSize(width: maxX - minX, height: maxY - minY))
    }
    
    var minXminYCorner: CGPoint {
        return CGPoint(x: minX, y: minY)
    }
    
    var minXmaxYCorner: CGPoint {
        return CGPoint(x: minX, y: maxY)
    }
    
    var maxXminYCorner: CGPoint {
        return CGPoint(x: maxX, y: minY)
    }
    
    var maxXmaxYCorner: CGPoint {
        return CGPoint(x: maxX, y: maxY)
    }
    
    var gridRect: Rect {
        return Rect(origin: origin.gridPoint, size: size.gridSize)
    }
}
