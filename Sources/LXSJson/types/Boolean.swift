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
}

extension JSON: ExpressibleByBooleanLiteral {
    
    public init(booleanLiteral value: Bool) {
        internalType = .boolean(value)
    }
}
