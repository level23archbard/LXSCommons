//
//  Parse.swift
//  LXSCommons
//
//  Created by Alex Rote on 11/10/21.
//  Copyright © 2021 Alex Rote. All rights reserved.
//

import Foundation

public extension JSON {
    
    /// Parse works similarly to its javascript counterpart. If the string is not a valid json object, an error will be thrown.
    static func parse(_ jsonString: String) throws -> JSON {
        let jsonData = jsonString.data(using: .utf8) ?? Data()
        return try parse(jsonData)
    }
    
    /// Parse works similarly to its javascript counterpart. If the data is not a valid json object, an error will be thrown.
    static func parse(_ jsonData: Data) throws -> JSON {
        guard jsonData != JSONInternalType.undefined.stringValue.data(using: .utf8) else { return .undefined }
        do {
            let object = try JSONSerialization.jsonObject(with: jsonData, options: .fragmentsAllowed)
            var json = JSON()
            json.internalType = JSONInternalType.fromNsObject(nsObject: object)
            return json
        } catch {
            throw ParsingError.invalidJsonInput
        }
    }
    
    enum ParsingError: Error {
        case invalidJsonInput
    }
}

fileprivate extension JSONInternalType {
    
    static func fromNsObject(nsObject: Any) -> JSONInternalType {
        // Note that we can never generate an 'undefined' from JSON NSObject representors
        if nsObject is NSNull {
            return .null
        } else if let number = nsObject as? NSNumber {
            if CFGetTypeID(number) == CFBooleanGetTypeID() {
                return .boolean(number.boolValue)
            } else {
                return .number(number.doubleValue)
            }
        } else if let string = nsObject as? NSString {
            return .string(string as String)
        } else if let nsArray = nsObject as? NSArray {
            guard let swiftArray = nsArray as? [Any] else { fatalError("Unrecognized NSArray from JSONSerialization, this should never happen!") }
            return .array(swiftArray.map { JSON(fromNsObject(nsObject: $0)) })
        } else if let nsDictionary = nsObject as? NSDictionary {
            guard let swiftDictionary = nsDictionary as? [String: Any] else { fatalError("Unrecognized NSDictionary from JSONSerialization, this should never happen!") }
            return .object(swiftDictionary.mapValues { JSON(fromNsObject(nsObject: $0)) })
        } else {
            fatalError("Unrecognized JSONSerialization output, this should never happen!")
        }
    }
}
