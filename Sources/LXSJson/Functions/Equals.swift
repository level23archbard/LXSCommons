//
//  Equals.swift
//  LXSCommons
//
//  Created by Alex Rote on 7/10/22.
//

public extension JSON {
    
    /// Returns whether the two data are loosely equal, mostly identical to using the javascript == operator. Note that objects and arrays will equate by value rather than by identity, thus different references can be considered equal.
    func isLooselyEqual(to json: JSON) -> Bool {
        // Same type uses strict equality
        if type == json.type {
            return isStrictlyEqual(to: json)
        // Null and undefined are loosely equal to each other
        } else if (type == .null && json.type == .undefined) || (type == .undefined && json.type == .null) {
            return true
        // Booleans are converted to numbers
        } else if type == .boolean {
            return toNumber.isLooselyEqual(to: json)
        } else if json.type == .boolean {
            return json.isLooselyEqual(to: self)
        // Strings and numbers comber by turning the string to a number
        } else if type == .number && json.type == .string {
            return isLooselyEqual(to: json.toNumber)
        } else if type == .string && json.type == .number {
            return json.isLooselyEqual(to: self)
        // Objects and arrays are converted the other type
        } else if type == .object || type == .array {
            if json.type == .number {
                return toNumber.isLooselyEqual(to: json)
            } else if json.type == .string {
                return toString.isLooselyEqual(to: json)
            } else {
                return false
            }
        } else if json.type == .object || json.type == .array {
            return json.isLooselyEqual(to: self)
        // Any other comparison is not equal
        } else {
            return false
        }
    }
    
    /// Returns whether the two data are loosely equal, mostly identical to using the javascript == operator. Note that objects and arrays will equate by value rather than by identity, thus different references can be considered equal.
    static func looselyEqual(_ json: JSON, _ otherJson: JSON) -> Bool {
        return json.isLooselyEqual(to: otherJson)
    }
    
    /// Returns whether the two data are strictly equal, mostly identical to using the javascript === operator. Note that objects and arrays will equate by value rather than by identity, thus different references can be considered equal.
    func isStrictlyEqual(to json: JSON) -> Bool {
        return self == json
    }
    
    /// Returns whether the two data are strictly equal, mostly identical to using the javascript === operator. Note that objects and arrays will equate by value rather than by identity, thus different references can be considered equal.
    static func strictlyEqual(_ json: JSON, _ otherJson: JSON) -> Bool {
        return json.isStrictlyEqual(to: otherJson)
    }
}
