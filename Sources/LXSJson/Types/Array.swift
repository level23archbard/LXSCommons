//
//  Array.swift
//  LXSCommons
//
//  Created by Alex Rote on 11/10/21.
//  Copyright © 2021 Alex Rote. All rights reserved.
//

public extension JSON {
    
    /// Initializes a JSON entry using an array of JSON values.
    init(value: [JSON]) {
        internalValue = .array(value)
    }
    
    /// Initializes a JSON entry using an array of JSON values, or 'undefined' if nil.
    init(value: [JSON]?) {
        if let value = value {
            self = JSON(value: value)
        } else {
            self = .undefined
        }
    }
    
    /// Initializes a JSON entry using an array of JSON values, or 'null' if nil.
    init(optionalValue: [JSON]?) {
        if let value = optionalValue {
            self = JSON(value: value)
        } else {
            self = .null
        }
    }
}

extension JSON: ExpressibleByArrayLiteral {
    
    public init(arrayLiteral elements: JSON...) {
        internalValue = .array(elements)
    }
}
