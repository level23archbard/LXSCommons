//
//  SwiftInteroperability.swift
//  LXSCommons
//
//  Created by Alex Rote on 12/5/19.
//

import Foundation

// Interoperability extensions for the following:
// String
// Data

public extension String {
    
    var nsString: NSString {
        return NSString(string: self)
    }
}

public extension Data {
    
    var nsData: NSData {
        return NSData(data: self)
    }
}
