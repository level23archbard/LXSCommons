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
        internalType = .string(value)
    }
}

extension JSON: ExpressibleByStringLiteral {
    
    public init(stringLiteral value: String) {
        internalType = .string(value)
    }
}
