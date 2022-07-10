//
//  JSON.swift
//  LXSCommons
//
//  Created by Alex Rote on 11/10/21.
//  Copyright © 2021 Alex Rote. All rights reserved.
//

/// The JSON struct holds an arbitrary piece of data. It is designed to be entirely flexible within its own operation, much like javascript data, and dynamic member lookup to simulate arbitrary accessing. It is also generally styled with Swift patterns and protocol support where it makes sense. When using JSON, perform as many operations within its context as possible before extracting it to Swift data. Due to dynamic property support, most operators are defined statically in addition to instanced. For example, `JSON.isTruthy(someJson)` rather than `someJson.isTruthy`. This can help clarify that the intended operation is not to use a JSON property. If a property is masked by a function, it can always be accessed by index as well. For example, `someJson["isTruthy"]` will always access a property in the JSON data itself.
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

// Extended in the declaring file. View the Equals functions for additional details. Note that, conforming with Swift definitions, this definitions of equals is the same as the javascript definition of the === operator.

extension JSON: Equatable {}
extension InternalValue: Equatable {}
