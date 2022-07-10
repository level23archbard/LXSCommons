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
            return internalValue.propertyGet(key: property)
        }
        set {
            internalValue.propertySet(key: property, value: newValue)
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
            self[key.internalValue.stringValue]
        }
        set {
            self[key.internalValue.stringValue] = newValue
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

public extension JSON {
    
    /// Returns an array containing all keys of the data. This will only return owned properties of the data. Unowned properties, such as keys of a string or properties such as `length`, will not be returned.
    var keys: [String] {
        return internalValue.keys ?? []
    }
    
    /// Returns an array containing all keys of the data. This will only return owned properties of the data. Unowned properties, such as keys of a string or properties such as `length`, will not be returned.
    static func keys(_ json: JSON) -> [String] {
        return json.keys
    }
    
    /// Returns an array containing all values of the data. This returns a Swift array, not a JSON array. This will only return owned properites of the data. Unowned properties, such as values in a string or properties such as `length`, will not be returned.
    var values: [JSON] {
        return internalValue.values ?? []
    }
    
    /// Returns an array containing all values of the data. This returns a Swift array, not a JSON array. This will only return owned properites of the data. Unowned properties, such as values in a string or properties such as `length`, will not be returned.
    static func values(_ json: JSON) -> [JSON] {
        return json.values
    }
}

public extension JSON {
    
    /// Similar to the javascript counterpart, returns if the JSON is an object or array that contains the given property itself.
    func hasOwnProperty(_ property: JSON) -> JSON {
        return JSON(value: internalValue.propertyCheck(key: property.internalValue.stringValue))
    }
    
    /// Similar to the javascript counterpart, returns if the JSON is an object or array that contains the given property itself.
    static func hasOwnProperty(_ json: JSON, property: JSON) -> JSON {
        return json.hasOwnProperty(property)
    }
}

extension InternalValue {
    
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
    
    var keys: [String]? {
        switch self {
        case .array(let array): return array.indices.map { String($0) }
        case .object(let dictionary): return Array(dictionary.keys)
        default: return nil
        }
    }
    
    var values: [JSON]? {
        switch self {
        case .array(let array): return array
        case .object(let dictionary): return Array(dictionary.values)
        default: return nil
        }
    }
}
