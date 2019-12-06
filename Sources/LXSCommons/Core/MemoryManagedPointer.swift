//
//  MemoryManagedPointer.swift
//  LXSCommons
//
//  Created by Alex Rote on 5/1/18.
//  Copyright © 2018 Alex Rote. All rights reserved.
//

public class MemoryManagedPointer<Element> {
    
    public var bytes: UnsafeMutablePointer<Element>
    
    public init(capturedPointer: UnsafeMutablePointer<Element>) {
        bytes = capturedPointer
    }
    
    deinit {
        bytes.deallocate()
    }
}
