//
//  SCNOctohedron.swift
//  LXSCommons
//
//  Created by Alex Rote on 2/28/19.
//  Copyright © 2019 Alex Rote. All rights reserved.
//

#if os(iOS)

import SceneKit

public class SCNOctohedron: SCNGeometry {
    
    public convenience init(width: Float = 1, height: Float = 1, length: Float = 1) {
        let up = SCNVector3.up * (height / 2)
        let right = SCNVector3.right * (width / 2)
        let forward = SCNVector3.forward * (length / 2)
        let left = SCNVector3.left * (width / 2)
        let backward = SCNVector3.backward * (length / 2)
        let down = SCNVector3.down * (height / 2)
        let vertices: [SCNVector3] = [
            up, right, forward,
            up, forward, left,
            up, left, backward,
            up, backward, right,
            down, forward, right,
            down, left, forward,
            down, backward, left,
            down, right, backward
        ]
        let normals: [SCNVector3] = [
            (up + right + forward).normalized, (up + right + forward).normalized, (up + right + forward).normalized,
            (up + forward + left).normalized, (up + forward + left).normalized, (up + forward + left).normalized,
            (up + backward + left).normalized, (up + backward + left).normalized, (up + backward + left).normalized,
            (up + right + backward).normalized, (up + right + backward).normalized, (up + right + backward).normalized,
            (down + right + forward).normalized, (down + right + forward).normalized, (down + right + forward).normalized,
            (down + forward + left).normalized, (down + forward + left).normalized, (down + forward + left).normalized,
            (down + backward + left).normalized, (down + backward + left).normalized, (down + backward + left).normalized,
            (down + right + backward).normalized, (down + right + backward).normalized, (down + right + backward).normalized,
        ]
        let triangles: [UInt8] = [
            0, 1, 2,
            3, 4, 5,
            6, 7, 8,
            9, 10, 11,
            12, 13, 14,
            15, 16, 17,
            18, 19, 20,
            21, 22, 23
        ]
        let verticesSource = SCNGeometrySource(vertices: vertices)
        let normalsSource = SCNGeometrySource(normals: normals)
        let trianglesElement = SCNGeometryElement(indices: triangles, primitiveType: .triangles)
        self.init(sources: [verticesSource, normalsSource], elements: [trianglesElement])
    }
}

#endif
