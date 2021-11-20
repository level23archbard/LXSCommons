//
//  ToBoolean.swift
//  LXSCommons
//
//  Created by Alex Rote on 11/10/21.
//  Copyright © 2021 Alex Rote. All rights reserved.
//

public extension JSON {
    
    /// Returns a new data converted to a boolean representation.
    func _toBoolean() -> JSON {
        return JSON(value: internalValue.truthy)
    }
    
    /// Returns a new data converted to a boolean representation.
    static func toBoolean(_ json: JSON) -> JSON {
        return json._toBoolean()
    }
    
    /// Returns the truthy value represented or coerced by the data.
    static func isTruthy(_ json: JSON) -> Bool {
        return json.internalValue.truthy
    }
}

extension InternalValue {
    
    var truthy: Bool {
        switch self {
        case .undefined: return false
        case .null: return false
        case .boolean(let bool): return bool
        case .number(let double): return !double.isZero
        case .string(let string): return !string.isEmpty
        case .array(_): return true
        case .object(_): return true
        }
    }
}
