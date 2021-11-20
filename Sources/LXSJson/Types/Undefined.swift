//
//  Undefined.swift
//  LXSCommons
//
//  Created by Alex Rote on 11/10/21.
//  Copyright © 2021 Alex Rote. All rights reserved.
//

public extension JSON {
    
    /// A static 'undefined' reference.
    static let undefined = JSON()
}

public extension JSON {
    
    /// Performs the 'delete' operator on the data, clearing all data and setting the reference to 'undefined'.
    static func delete(data json: inout JSON) {
        json.internalValue = .undefined
    }
}
