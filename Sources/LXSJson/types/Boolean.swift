//
//  Boolean.swift
//  LXSCommons
//
//  Created by Alex Rote on 11/10/21.
//  Copyright © 2021 Alex Rote. All rights reserved.
//

public extension JSON {
    
    /// A static 'true' reference.
    static let `true`: JSON = true
    
    /// A static 'false' reference.
    static let `false`: JSON = false
    
    /// Initializes a JSON entry using a boolean value.
    init(value: Bool) {
        self = value ? .true : .false
    }
    
    /// Initializes a JSON entry using a boolean value, or 'undefined' if nil.
    init(value: Bool?) {
        if let value = value {
            self = JSON(value: value)
        } else {
            self = .undefined
        }
    }
    
    /// Initializes a JSON entry using a boolean value, or 'null' if nil.
    init(optionalValue: Bool?) {
        if let value = optionalValue {
            self = JSON(value: value)
        } else {
            self = .null
        }
    }
}

extension JSON: ExpressibleByBooleanLiteral {
    
    public init(booleanLiteral value: Bool) {
        internalValue = .boolean(value)
    }
}
