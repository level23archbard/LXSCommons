//
//  TypeOf.swift
//  LXSCommons
//
//  Created by Alex Rote on 11/10/21.
//  Copyright © 2021 Alex Rote. All rights reserved.
//

public extension JSON {
    
    /// The JSON Type of the data.
    enum JSONType: String {
        /// Undefined, represents that the data does not participate in a JSON document.
        case undefined
        /// Null, represented by the 'null' keyword.
        case null
        /// Boolean, represented by either the 'true' or 'false' keyword.
        case boolean
        /// Number, represented by either an integer or floating point number.
        case number
        /// String, represented by any sequence of characters within ""s.
        case string
        /// Array, represented by any inner JSON entries, surrounded by []s and separated by ,s. Note that, unlike javascript, arrays are a distinct JSONType from objects.
        case array
        /// Object, represented by inner entries of string keys and JSON values separated by :s, where all entry pairs are separated by ,s and surrounded {}s.
        case object
    }
    
    /// Returns the type of the JSON data.
    static func typeOf(_ json: JSON) -> JSONType {
        return json.internalType.type
    }
    
    /// Returns a JSON check whether the JSON data's type matches the requested type.
    static func instanceOf(_ json: JSON, type: JSONType) -> JSON {
        return JSON(value: json.internalType.type == type)
    }
}

extension JSONInternalType {
    
    var type: JSON.JSONType {
        switch self {
        case .undefined: return .undefined
        case .null: return .null
        case .boolean(_): return .boolean
        case .number(_): return .number
        case .string(_): return .string
        case .array(_): return .array
        case .object(_): return .object
        }
    }
}
