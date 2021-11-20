//
//  Null.swift
//  LXSCommons
//
//  Created by Alex Rote on 11/10/21.
//  Copyright © 2021 Alex Rote. All rights reserved.
//

public extension JSON {
    
    /// A static 'null' reference.
    static let null: JSON = nil
}

extension JSON: ExpressibleByNilLiteral {
    
    public init(nilLiteral: ()) {
        internalValue = .null
    }
}
