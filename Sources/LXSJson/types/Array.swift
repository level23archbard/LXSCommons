//
//  Array.swift
//  LXSCommons
//
//  Created by Alex Rote on 11/10/21.
//  Copyright © 2021 Alex Rote. All rights reserved.
//

extension JSON: ExpressibleByArrayLiteral {
    
    public init(arrayLiteral elements: JSON...) {
        internalType = .array(elements)
    }
}
