//
//  Properties.swift
//  LXSCommons
//
//  Created by Alex Rote on 11/11/21.
//  Copyright © 2021 Alex Rote. All rights reserved.
//

public extension JSON {
    
    subscript(property: String) -> JSON {
        get {
            return internalType.propertyGet(key: property)
        }
        set {
            internalType.propertySet(key: property, value: newValue)
        }
    }
    
    subscript(index: Int) -> JSON {
        get {
            self[String(index)]
        }
        set {
            self[String(index)] = newValue
        }
    }
    
    subscript(key: JSON) -> JSON {
        get {
            self[JSON.stringValue(key)]
        }
        set {
            self[JSON.stringValue(key)] = newValue
        }
    }
    
    subscript(dynamicMember member: String) -> JSON {
        get {
            self[member]
        }
        set {
            self[member] = newValue
        }
    }
}

extension JSON {
    
    static func hasOwnProperty(_ json: JSON, property: String) -> Bool {
        return json.internalType.propertyCheck(key: property)
    }
}

extension JSONInternalType {
    
    func propertyGet(key: String) -> JSON {
        switch self {
        case .array(let array):
            guard let index = Int(key), index < array.count else { return .undefined }
            return array[index]
        case .object(let dictionary):
            return dictionary[key] ?? .undefined
        default: return .undefined
        }
    }
    
    mutating func propertySet(key: String, value: JSON) {
        switch self {
        case .array(var array):
            // We're making a bit of a difference from both JS and from JSON. If item is an array, we're going to keep it fixed as an array, only allow index keys, and only allow pushing up to next index
            guard let index = Int(key), index <= array.count else { return }
            if index == array.count {
                array.append(value)
            } else {
                array[index] = value
            }
            self = .array(array)
        case .object(var dictionary):
            dictionary[key] = value
            self = .object(dictionary)
        default: return
        }
    }
    
    func propertyCheck(key: String) -> Bool {
        switch self {
        case .array(let array):
            guard let index = Int(key) else { return false }
            return index < array.count
        case .object(let dictionary):
            return dictionary.keys.contains(key)
        default: return false
        }
    }
}
