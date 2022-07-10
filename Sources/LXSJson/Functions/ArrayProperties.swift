//
//  ArrayProperties.swift
//  LXSCommons
//
//  Created by Alex Rote on 11/13/21.
//  Copyright © 2021 Alex Rote. All rights reserved.
//

public extension JSON {
    
    /// Returns the length of the string or array, or undefined if the JSON is neither type of data.
    var length: JSON {
        return JSON(value: internalValue.lengthValue)
    }
    
    /// Returns the length of the string or array, or undefined if the JSON is neither type of data.
    static func lengthOf(_ json: JSON) -> JSON {
        return json.length
    }
    
    /// Pushes the value to the end of the string or array, and returns the new length.
    @discardableResult mutating func push(_ json: JSON) -> JSON {
        internalValue.elements?.append(json)
        return length
    }
    
    /// Pushes the value to the end of the string or array, and returns the new length.
    @discardableResult static func push(_ json: inout JSON, value: JSON) -> JSON {
        return json.push(value)
    }
    
    /// Pops the last value from the end of the string or array, and returns the value.
    @discardableResult mutating func pop() -> JSON {
        return internalValue.elements?.popLast() ?? .undefined
    }
    
    /// Pops the last value from the end of the string or array, and returns the value.
    @discardableResult static func pop(_ json: inout JSON) -> JSON {
        return json.pop()
    }
    
    /// Iterates through the string or array, running the closure on each element.
    func forEach(_ block: (_ json: JSON) -> ()) {
        forEach { json, _ in
            block(json)
        }
    }
    
    /// Iterates through the string or array, running the closure on each element and index.
    func forEach(_ block: (_ json: JSON, _ index: Int) -> ()) {
        guard let elements = internalValue.elements else { return }
        for (index, element) in elements.enumerated() {
            block(element, index)
        }
    }
    
    /// Iterates through the string or array, running the closure on each element.
    static func forEach(_ json: JSON, _ block: (_ json: JSON) -> ()) {
        json.forEach(block)
    }
    
    /// Iterates through the string or array, running the closure on each element and index.
    static func forEach(_ json: JSON, _ block: (_ json: JSON, _ index: Int) -> ()) {
        json.forEach(block)
    }
    
    /// Iterates through the string or array, running the closure on each element. This variant exposes each entry for modification.
    mutating func modEach(_ block: (_ json: inout JSON) -> ()) {
        modEach { json, _ in
            block(&json)
        }
    }
    
    /// Iterates through the string or array, running the closure on each element and index. This variant exposes each entry for modification.
    mutating func modEach(_ block: (_ json: inout JSON, _ index: Int) -> ()) {
        guard var elements = internalValue.elements else { return }
        for index in elements.indices {
            block(&elements[index], index)
        }
        internalValue.elements = elements
    }
    
    /// Iterates through the string or array, running the closure on each element. This variant exposes each entry for modification.
    static func modEach(_ json: inout JSON, _ block: (_ json: inout JSON) -> ()) {
        json.modEach(block)
    }
    
    /// Iterates through the string or array, running the closure on each element and index. This variant exposes each entry for modification.
    static func modEach(_ json: inout JSON, _ block: (_ json: inout JSON, _ index: Int) -> ()) {
        json.modEach(block)
    }
    
    /// Returns the value of the first element that satisfies the closure, or the JSON value undefined.
    func find(where block: (_ json: JSON) -> Bool) -> JSON {
        find { json, _ in
            block(json)
        }
    }
    
    /// Returns the value of the first element that satisfies the closure, or the JSON value undefined.
    func find(where block: (_ json: JSON, _ index: Int) -> Bool) -> JSON {
        guard let elements = internalValue.elements else { return .undefined }
        for (index, element) in elements.enumerated() {
            if block(element, index) {
                return element
            }
        }
        return .undefined
    }
    
    /// Returns the value of the first element that satisfies the closure, or the JSON value undefined.
    static func find(_ json: JSON, where block: (_ json: JSON) -> Bool) -> JSON {
        return json.find(where: block)
    }
    
    /// Returns the value of the first element that satisfies the closure, or the JSON value undefined.
    static func find(_ json: JSON, where block: (_ json: JSON, _ index: Int) -> Bool) -> JSON {
        return json.find(where: block)
    }
}

extension InternalValue {
    
    var lengthValue: Int? {
        switch self {
        case .string(let string): return string.count
        case .array(let array): return array.count
        default: return nil
        }
    }
    
    var elements: [JSON]? {
        get {
            switch self {
            case .string(let string): return string.map { JSON(value: String($0)) }
            case .array(let array): return array
            default: return nil
            }
        }
        set {
            guard let newValue = newValue else { return }
            switch self {
            case .string(_): self = .string(newValue.map { $0.internalValue.stringValue }.joined())
            case .array(_): self = .array(newValue)
            default: break
            }
        }
    }
}
