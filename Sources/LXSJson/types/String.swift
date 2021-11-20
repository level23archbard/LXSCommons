//
//  String.swift
//  LXSCommons
//
//  Created by Alex Rote on 11/10/21.
//  Copyright © 2021 Alex Rote. All rights reserved.
//

public extension JSON {
    
    /// Initializes a JSON entry using a string value.
    init(value: String) {
        internalValue = .string(value)
    }
    
    /// Initializes a JSON entry using a string value, or 'undefined' if nil.
    init(value: String?) {
        if let value = value {
            self = JSON(value: value)
        } else {
            self = .undefined
        }
    }
    
    /// Initializes a JSON entry using a string value, or 'null' if nil.
    init(optionalValue: String?) {
        if let value = optionalValue {
            self = JSON(value: value)
        } else {
            self = .null
        }
    }
}

extension JSON: ExpressibleByStringLiteral {
    
    public init(stringLiteral value: String) {
        internalValue = .string(value)
    }
}
