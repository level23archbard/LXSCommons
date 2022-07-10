//
//  ToString.swift
//  LXSCommons
//
//  Created by Alex Rote on 11/10/21.
//  Copyright © 2021 Alex Rote. All rights reserved.
//

public extension JSON {
    
    /// Returns a new data converted to a string representation.
    var toString: JSON {
        return JSON(value: internalValue.stringValue)
    }
    
    /// Returns a new data converted to a string representation.
    static func toString(_ json: JSON) -> JSON {
        return json.toString
    }
    
    /// Returns the string value represented or coerced by the data.
    var stringValue: String {
        return internalValue.stringValue
    }
    
    /// Returns the string value represented or coerced by the data.
    static func stringValue(_ json: JSON) -> String {
        return json.stringValue
    }
}

extension InternalValue {
    
    var stringValue: String {
        switch self {
        case .undefined: return "undefined"
        case .null: return "null"
        case .boolean(let bool): return bool ? "true" : "false"
        case .number(let double):
            if double.truncatingRemainder(dividingBy: 1) == 0 {
                return String(format: "%.0f", double)
            } else {
                return String(double)
            }
        case .string(let string): return string
        case .array(let array): return array.map { $0.internalValue.stringValue }.joined(separator: ",")
        case .object(_): return "[object Object]" // The lovely
        }
    }
}
