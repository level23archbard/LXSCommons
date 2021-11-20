//
//  Object.swift
//  LXSCommons
//
//  Created by Alex Rote on 11/10/21.
//  Copyright © 2021 Alex Rote. All rights reserved.
//

public extension JSON {
    
    /// Initializes a JSON entry using a dictionary of JSON values.
    init(value: [String: JSON]) {
        internalValue = .object(value)
    }
    
    /// Initializes a JSON entry using a dictionary of JSON values, or 'undefined' if nil.
    init(value: [String: JSON]?) {
        if let value = value {
            self = JSON(value: value)
        } else {
            self = .undefined
        }
    }
    
    /// Initializes a JSON entry using a dictionary of JSON values, or 'null' if nil.
    init(optionalValue: [String: JSON]?) {
        if let value = optionalValue {
            self = JSON(value: value)
        } else {
            self = .null
        }
    }
}

extension JSON: ExpressibleByDictionaryLiteral {
    
    // Note that, like javascript, duplicate keys will overwrite using last-wins. Also, be aware that Swift dictionary literal is square-brackets, not curly-brackets as in javascript!
    public init(dictionaryLiteral elements: (String, JSON)...) {
        var obj = [String: JSON]()
        for (key, value) in elements {
            obj[key] = value
        }
        internalValue = .object(obj)
    }
}
