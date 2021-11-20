//
//  JSON.swift
//  LXSCommons
//
//  Created by Alex Rote on 11/10/21.
//  Copyright © 2021 Alex Rote. All rights reserved.
//

/// The JSON struct holds an arbitrary piece of data. It is designed to be entirely flexible within its own operation, much like javascript data. When using JSON, perform as many operations within its context as possible before extracting it to Swift data. Due to dynamic property support, most operators are defined statically rather than by instance. For example, `JSON.isTruthy(someJson)` rather than `someJson.isTruthy`. This allows for the possibility of the JSON data underneath actually allowing the key, isTruthy, to be read as-is instead of requiring certain overrides. Apart from this, certain operators will also be defined by instance as functions, when inputs and outputs all operate within JSON data. These operator functions will always be prefixed by an underscore, to grant space between them and a possible property. For example, `someJson._length()` rather than `someJson.length`. For these operators, the statically defined operator will also be available for use.
@dynamicMemberLookup
public struct JSON {
    
    // The internalValue contains all physical properties of the data.
    internal var internalValue: InternalValue
    
    /// Initializing an empty JSON will create an 'undefined' entry.
    public init() {
        internalValue = .undefined
    }
    
    /// Package shortcut to initialize JSON
    internal init(_ internalValue: InternalValue) {
        self.internalValue = internalValue
    }
}

// The supported JSON types. Note that array is distinct from object, unlike strict javascript, for purposes of cleaner tracking to and from true JSON.
internal enum InternalValue {
    // Undefined is supported in JSON objects, in that it will not write to new JSON structures.
    case undefined
    // Null is supported by writing 'null' into JSON structures.
    case null
    // Boolean supports writing 'true' and 'false' into JSON structures.
    case boolean(Bool)
    // Number supports writing either integers or doubles into JSON structures, though is represented by Double internally.
    case number(Double)
    // Strings will write themselves into JSON structures.
    case string(String)
    // Arrays will write square-braced lists into JSON structures.
    case array([JSON])
    // Objects will write curly-braced key-values into JSON structures.
    case object([String: JSON])
}
