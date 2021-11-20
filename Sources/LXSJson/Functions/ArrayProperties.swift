//
//  ArrayProperties.swift
//  LXSCommons
//
//  Created by Alex Rote on 11/13/21.
//  Copyright © 2021 Alex Rote. All rights reserved.
//

public extension JSON {
    
    /// Returns the length of the string or array, or undefined if the JSON is neither type of data.
    func _length() -> JSON {
        return JSON(value: internalValue.lengthValue)
    }
    
    /// Pushes the value to the end of the string or array, and returns the new length.
    @discardableResult mutating func _push(_ json: JSON) -> JSON {
        internalValue.elements?.append(json)
        return _length()
    }
    
    /// Pops the last value from the end of the string or array, and returns the value.
    @discardableResult mutating func _pop() -> JSON {
        return internalValue.elements?.popLast() ?? .undefined
    }
    
    /// Iterates through the string or array, running the closure on each element.
    func _forEach(_ block: (_ json: JSON) -> ()) {
        _forEach { json, _ in
            block(json)
        }
    }
    
    /// Iterates through the string or array, running the closure on each element and index.
    func _forEach(_ block: (_ json: JSON, _ index: Int) -> ()) {
        guard let elements = internalValue.elements else { return }
        for (index, element) in elements.enumerated() {
            block(element, index)
        }
    }
    
    /// Iterates through the string or array, running the closure on each element. This variant exposes each entry for modification.
    mutating func _modEach(_ block: (_ json: inout JSON) -> ()) {
        _modEach { json, _ in
            block(&json)
        }
    }
    
    /// Iterates through the string or array, running the closure on each element and index. This variant exposes each entry for modification.
    mutating func _modEach(_ block: (_ json: inout JSON, _ index: Int) -> ()) {
        guard var elements = internalValue.elements else { return }
        for index in elements.indices {
            block(&elements[index], index)
        }
        internalValue.elements = elements
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
