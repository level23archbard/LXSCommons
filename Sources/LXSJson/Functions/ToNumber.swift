//
//  ToNumber.swift
//  LXSCommons
//
//  Created by Alex Rote on 11/10/21.
//  Copyright © 2021 Alex Rote. All rights reserved.
//

public extension JSON {
    
    /// Returns a new data converted to a number representation. Note that unlike javascript, JSON does not support NaN number representations, these will be converted to undefined instead.
    static func toNumber(_ json: JSON) -> JSON {
        if let value = JSON.doubleValue(json) {
            return JSON(value: value)
        } else {
            return .undefined
        }
    }
    
    /// Returns the double value represented or coerced by the data.
    static func doubleValue(_ json: JSON) -> Double? {
        return json.internalType.doubleValue
    }
}

extension JSONInternalType {
    
    var doubleValue: Double? {
        switch self {
        case .undefined: return nil
        case .null: return 0
        case .boolean(let bool): return bool ? 1 : 0
        case .number(let double): return double
        case .string(let string):
            if string.isEmpty {
                return 0
            }
            return Double(string)
        case .array(let array):
            if array.isEmpty {
                return 0
            } else if array.count == 1, let onlyItem = array.first {
                return onlyItem.internalType.doubleValue
            } else {
                return nil
            }
        case .object(_): return nil
        }
    }
}
