//
//  Number.swift
//  LXSCommons
//
//  Created by Alex Rote on 11/10/21.
//  Copyright © 2021 Alex Rote. All rights reserved.
//

public extension JSON {
    
    /// Initializes a JSON entry using an integer value. Note that JSON numbers allow floating point precision, so it may not always be possible to extract the value back.
    init(value: Int) {
        internalValue = .number(Double(value))
    }
    
    /// Initializes a JSON entry using a double value.
    init(value: Double) {
        internalValue = .number(value)
    }
    
    /// Initializes a JSON entry using an integer value, or 'undefined' if nil. Note that JSON numbers allow floating point precision, so it may not always be possible to extract the value back.
    init(value: Int?) {
        if let value = value {
            self = JSON(value: value)
        } else {
            self = .undefined
        }
    }
    
    /// Initializes a JSON entry using a double value, or 'undefined' if nil.
    init(value: Double?) {
        if let value = value {
            self = JSON(value: value)
        } else {
            self = .undefined
        }
    }
    
    /// Initializes a JSON entry using an integer value, or 'null' if nil. Note that JSON numbers allow floating point precision, so it may not always be possible to extract the value back.
    init(optionalValue: Int?) {
        if let value = optionalValue {
            self = JSON(value: value)
        } else {
            self = .null
        }
    }
    
    /// Initializes a JSON entry using a double value, or 'null' if nil.
    init(optionalValue: Double?) {
        if let value = optionalValue {
            self = JSON(value: value)
        } else {
            self = .null
        }
    }
}

extension JSON: ExpressibleByIntegerLiteral, ExpressibleByFloatLiteral {
    
    public init(integerLiteral value: Int) {
        internalValue = .number(Double(value))
    }
    
    public init(floatLiteral value: Double) {
        internalValue = .number(value)
    }
}
