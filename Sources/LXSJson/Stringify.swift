//
//  Stringify.swift
//  LXSCommons
//
//  Created by Alex Rote on 11/10/21.
//  Copyright © 2021 Alex Rote. All rights reserved.
//

import Foundation

public extension JSON {
    
    /// Stringify works similar to its javascript counterpart.
    static func stringify(_ json: JSON, prettify: Bool = false) -> String {
        return String(data: stringifyData(json, prettify: prettify), encoding: .utf8) ?? ""
    }
    
    /// Stringify works similar to its javascript counterpart. This variant outputs data instead of a string, though its contents are the same.
    static func stringifyData(_ json: JSON, prettify: Bool = false) -> Data {
        if let nsObject = json.internalType.nsObjectify() {
            var options: JSONSerialization.WritingOptions = .fragmentsAllowed
            if prettify {
                options.insert(.prettyPrinted)
            }
            do {
                return try JSONSerialization.data(withJSONObject: nsObject, options: options)
            } catch {
                fatalError("Error trying to stringify JSON data, this should never happen! Error: \(error)")
            }
        } else {
            return JSONInternalType.undefined.stringValue.data(using: .utf8) ?? Data()
        }
    }
}

fileprivate extension JSONInternalType {
    
    // JSONSerialization operates on NSObject types, so turn into the corresponding type here.
    func nsObjectify() -> NSObject? {
        switch self {
        case .undefined:
            return nil
        case .null:
            return NSNull()
        case .boolean(let boolean):
            return NSNumber(value: boolean)
        case .number(let double):
            return NSNumber(value: double) // JSONSerializer seems to make sure this is properly represented
        case .string(let string):
            return NSString(string: string)
        case .array(let array):
            return NSArray(array: array.map { $0.internalType.nsObjectify() }.filter { $0 != nil }.map { $0 as Any })
        case .object(let dictionary):
            let nsDictionary = NSMutableDictionary()
            for (key, value) in dictionary {
                if let nsObject = value.internalType.nsObjectify() {
                    nsDictionary.setObject(nsObject, forKey: NSString(string: key))
                }
            }
            return NSDictionary(dictionary: nsDictionary)
        }
    }
}
