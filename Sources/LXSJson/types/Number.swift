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
        internalType = .number(Double(value))
    }
    
    /// Initializes a JSON entry using a double value.
    init(value: Double) {
        internalType = .number(value)
    }
}

extension JSON: ExpressibleByIntegerLiteral, ExpressibleByFloatLiteral {
    
    public init(integerLiteral value: Int) {
        internalType = .number(Double(value))
    }
    
    public init(floatLiteral value: Double) {
        internalType = .number(value)
    }
}
