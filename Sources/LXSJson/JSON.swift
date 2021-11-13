//
//  JSON.swift
//  LXSCommons
//
//  Created by Alex Rote on 11/10/21.
//  Copyright © 2021 Alex Rote. All rights reserved.
//

/// The JSON struct holds an arbitrary piece of data. It is designed to be entirely flexible within its own operation, much like javascript data. When using JSON, perform as many operations within its context as possible before extracting it to Swift data. Due to dynamic property support, most operators are going to be defined statically rather than by instance. For instance, `JSON.isTruthy(someJson)` rather than `someJson.isTruthy`. This allows for the possibility of the JSON data underneath actually allowing the key, isTruthy, to be read as-is instead of requiring certain overrides.
@dynamicMemberLookup
public struct JSON {
    
    // The internalType contains all physical properties of the data.
    var internalType: JSONInternalType
    
    /// Initializing an empty JSON will create an 'undefined' entry.
    public init() {
        internalType = .undefined
    }
    
    /// Package shortcut to initialize JSON
    internal init(_ internalType: JSONInternalType) {
        self.internalType = internalType
    }
}

// The supported JSON types. Note that array is distinct from object, unlike strict javascript, for purposes of cleaner tracking to and from true JSON.
enum JSONInternalType {
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
