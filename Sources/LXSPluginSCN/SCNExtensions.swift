//
//  SCNExtensions.swift
//  LXSCommons
//
//  Created by Alex Rote on 2/25/19.
//  Copyright © 2019 Alex Rote. All rights reserved.
//

#if os(iOS)

import SceneKit

// Extensions relating to SceneKit classes
// SCNVector3
//
// Extensions relating to SceneKit interoperabilities
// CGVector

public extension SCNVector3 {
    
    static let zero = SCNVector3Zero
    static let right = SCNVector3(1, 0, 0)
    static let left = SCNVector3(-1, 0, 0)
    static let up = SCNVector3(0, 1, 0)
    static let down = SCNVector3(0, -1, 0)
    static let backward = SCNVector3(0, 0, 1)
    static let forward = SCNVector3(0, 0, -1)
    
    var length: Float {
        return sqrtf((x * x) + (y * y) + (z * z))
    }
    
    var normalized: SCNVector3 {
        let tmpLength = length
        if tmpLength == 0 {
            return .zero
        } else {
            return SCNVector3(x / tmpLength, y / tmpLength, z / tmpLength)
        }
    }
    
    mutating func normalize() {
        let normal = normalized
        x = normal.x
        y = normal.y
        z = normal.z
    }
    
    static func + (left: SCNVector3, right: SCNVector3) -> SCNVector3 {
        return SCNVector3(left.x + right.x, left.y + right.y, left.z + right.z)
    }
    
    static func - (left: SCNVector3, right: SCNVector3) -> SCNVector3 {
        return SCNVector3(left.x - right.x, left.y - right.y, left.z - right.z)
    }
    
    static func * (left: SCNVector3, right: Float) -> SCNVector3 {
        return SCNVector3(left.x * right, left.y * right, left.z * right)
    }
    
    static func * (left: Float, right: SCNVector3) -> SCNVector3 {
        return right * left
    }
    
    static func / (left: SCNVector3, right: Float) -> SCNVector3 {
        return SCNVector3(left.x / right, left.y / right, left.z / right)
    }
    
    static func += (left: inout SCNVector3, right: SCNVector3) {
        left = left + right
    }
    
    static func *= (left: inout SCNVector3, right: Float) {
        left = left * right
    }
}

public extension CGVector {
    
    var scnVector3XY: SCNVector3 {
        return SCNVector3(dx, dy, 0)
    }
    
    var scnVector3XZ: SCNVector3 {
        return SCNVector3(dx, 0, dy)
    }
    
    var scnVector3YZ: SCNVector3 {
        return SCNVector3(0, dx, dy)
    }
}

#endif
