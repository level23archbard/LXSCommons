//
//  NSExtensions.swift
//  LXSCommons
//
//  Created by Alex Rote on 3/19/17.
//  Copyright © 2017 Alex Rote. All rights reserved.
//

import Foundation

// Extensions relating to Foundation and Cocoa classes
// NSString

public extension NSString {
    
    var fullRange: NSRange {
        return NSRange(location: 0, length: length)
    }
}
