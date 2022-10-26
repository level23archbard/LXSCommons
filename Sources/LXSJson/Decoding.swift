//
//  Decoding.swift
//  LXSCommons
//
//  Created by Alex Rote on 11/13/21.
//  Copyright © 2021 Alex Rote. All rights reserved.
//

extension JSON {
    
    /// The JSON.Decoder acts similarly to the standard JSONDecoder, except it converts the codable item from a JSON struct as opposed to some data.
    public struct Decoder {
        
        /// Creates a new Decoder.
        public init() {}
        
        /// Decode the type from an appropriate JSON struct, as opposed to some data.
        public func decode<T: Decodable>(_ type: T.Type, from json: JSON) throws -> T {
            let decoder = JSONInternalDecoder(json: json, options: options)
            return try type.init(from: decoder)
        }
        
        /// A possible decoding error that can occur while decoding a type from a JSON struct.
        public enum Error: Swift.Error {
            /// A non-number attempted to decode into a number.
            case decodingNaN
            /// A non-string attempted to decode into a string, and the string parsing strategy is set to asOptionalOrError or error.
            case decodingStringWithInvalidData
            /// An unexpected type conversion occurred during value decoding. This should not happen, but may indicate an unusual type attempted to decode a standard JSON data, which is not allowed.
            case unexpectedConversion
            /// A superclass has defined a conflicting structure to a subclass. This can occur when an unkeyed subclass and superclass compete for the same resource.
            case superclassStructureConflict
        }
        
        /// A possible strategy for how to decode a JSON value into a string, in the case the JSON value is not a string.
        public enum StringParsingStrategy {
            /// The value will be filled with the JSON data's string value, as if toString was called.
            case asStringValue
            /// The value will be filled with an empty string.
            case asEmpty
            /// A decoding error JSON.Decoder.Error.decodingStringWithInvalidData will be thrown.
            case error
        }
        
        /// The possible string parsing options available when different JSON types are encountered. If a string type is encountered, the string is always parsed to a valid string. Otherwise, parsing is handled based on how the corresponding type is set.
        public struct StringParsingOptions {
            /// The strategy for how an undefined JSON data will be parsed to a string.
            public var undefinedParsing = StringParsingStrategy.error
            /// The strategy for how a null JSON data will be parsed to a string.
            public var nullParsing = StringParsingStrategy.error
            /// The strategy for how a string JSON data will be parsed to a string. This is always fixed.
            public let stringParsing = StringParsingStrategy.asStringValue
            /// The strategy for how a number JSON data will be parsed to a string.
            public var numberParsing = StringParsingStrategy.asStringValue
            /// The strategy for how a boolean JSON data will be parsed to a string.
            public var booleanParsing = StringParsingStrategy.asStringValue
            /// The strategy for how an array JSON data will be parsed to a string.
            public var arrayParsing = StringParsingStrategy.error
            /// The strategy for how an object JSON data will be parsed to a string.
            public var objectParsing = StringParsingStrategy.error
            
            /// The default string parsing options.
            public static let `default` = StringParsingOptions()
            
            fileprivate func strategy(for type: JSONType) -> StringParsingStrategy {
                switch type {
                case .undefined: return undefinedParsing
                case .null: return nullParsing
                case .boolean: return booleanParsing
                case .number: return numberParsing
                case .string: return stringParsing
                case .array: return arrayParsing
                case .object: return objectParsing
                }
            }
            
            private init() {}
        }
        
        /// The possible options available when decoding JSON data.
        public struct Options {
            /// These options relate to how strings are parsed from different kinds of JSON data.
            public var stringParsingOptions = StringParsingOptions.default
            
            /// The default options.
            public static let `default` = Options()
            
            private init() {}
        }
        
        /// The possible options available when decoding JSON data.
        public var options = Options.default
    }
}

// This file is a bit less busy than Encoding, but still broken down about the same.

// The "Decoder"s job is to serve as a first responder to an object's init(from:) function, and usually just serves one purpose to dispatch a single, appropriate container that describes the object. After dispatch, the decoder is unused.
fileprivate class JSONInternalDecoder: Decoder {
    
    let json: JSON
    let codingPath: [CodingKey]
    let userInfo: [CodingUserInfoKey: Any]
    let options: JSON.Decoder.Options
    
    init(json: JSON, codingPath: [CodingKey] = [], userInfo: [CodingUserInfoKey: Any] = [:], options: JSON.Decoder.Options) {
        self.json = json
        self.codingPath = codingPath
        self.userInfo = userInfo
        self.options = options
    }
    
    func container<Key>(keyedBy type: Key.Type) throws -> KeyedDecodingContainer<Key> where Key : CodingKey {
        return KeyedDecodingContainer(KeyedContainer<Key>(json: json, codingPath: codingPath, userInfo: userInfo, options: options))
    }
    
    func unkeyedContainer() throws -> UnkeyedDecodingContainer {
        return UnkeyedContainer(json: json, codingPath: codingPath, userInfo: userInfo, options: options)
    }
    
    func singleValueContainer() throws -> SingleValueDecodingContainer {
        return SingleValueContainer(json: json, codingPath: codingPath, userInfo: userInfo, options: options)
    }
}

// The "KeyedContainer"s job is to read JSON objects. For simplicity, all values are routed into the "SingleValueContainer" to determine appropriate values, except for explicit requests to create new containers.

extension JSONInternalDecoder {
    
    class KeyedContainer<Key: CodingKey>: KeyedDecodingContainerProtocol {
        
        let json: JSON
        let codingPath: [CodingKey]
        let userInfo: [CodingUserInfoKey: Any]
        let options: JSON.Decoder.Options
        
        init(json: JSON, codingPath: [CodingKey], userInfo: [CodingUserInfoKey: Any], options: JSON.Decoder.Options) {
            self.json = json
            self.codingPath = codingPath
            self.userInfo = userInfo
            self.options = options
        }
        
        var allKeys: [Key] {
            guard case let .object(contentJson) = json.internalValue else { return [] }
            return contentJson.keys.compactMap { Key(stringValue: $0) }
        }
        
        func contains(_ key: Key) -> Bool {
            guard case let .object(contentJson) = json.internalValue else { return false }
            return contentJson.keys.contains(key.stringValue)
        }
        
        func decodeNil(forKey key: Key) throws -> Bool {
            return SingleValueContainer(json: json[key.stringValue], codingPath: codingPath, userInfo: userInfo, options: options).decodeNil()
        }
        
        func decode<T>(_ type: T.Type, forKey key: Key) throws -> T where T : Decodable {
            return try SingleValueContainer(json: json[key.stringValue], codingPath: codingPath, userInfo: userInfo, options: options).decode(type)
        }
        
        func nestedContainer<NestedKey>(keyedBy type: NestedKey.Type, forKey key: Key) throws -> KeyedDecodingContainer<NestedKey> where NestedKey : CodingKey {
            return KeyedDecodingContainer(KeyedContainer<NestedKey>(json: json[key.stringValue], codingPath: codingPath + [key], userInfo: userInfo, options: options))
        }
        
        func nestedUnkeyedContainer(forKey key: Key) throws -> UnkeyedDecodingContainer {
            return UnkeyedContainer(json: json[key.stringValue], codingPath: codingPath + [key], userInfo: userInfo, options: options)
        }
        
        func superDecoder() throws -> Decoder {
            return JSONInternalDecoder(json: json, codingPath: codingPath, userInfo: userInfo, options: options)
        }
        
        func superDecoder(forKey key: Key) throws -> Decoder {
            return JSONInternalDecoder(json: json[key.stringValue], codingPath: codingPath + [key], userInfo: userInfo, options: options)
        }
    }
}

// The "UnkeyedContainer"s job is to read JSON arrays. For simplicity, all things are routed into the "SingleValueContainer" to determine appropriate values, except for explicit requests to create new containers. Order is tracked, and hence competing for the same container resource between subclass and superclass is not allowed.

extension JSONInternalDecoder {
    
    class UnkeyedContainer: UnkeyedDecodingContainer {
        
        let json: JSON
        let codingPath: [CodingKey]
        let userInfo: [CodingUserInfoKey: Any]
        let options: JSON.Decoder.Options
        
        init(json: JSON, codingPath: [CodingKey], userInfo: [CodingUserInfoKey: Any], options: JSON.Decoder.Options) {
            self.json = json
            self.codingPath = codingPath
            self.userInfo = userInfo
            self.options = options
        }
        
        var count: Int? {
            guard case let .array(contentJson) = json.internalValue else { return 0 }
            return contentJson.count
        }
        
        var isAtEnd: Bool {
            return currentIndex >= (count ?? 0)
        }
        
        var currentIndex: Int = 0
        
        func decodeNil() throws -> Bool {
            let isNil = SingleValueContainer(json: json[currentIndex], codingPath: codingPath, userInfo: userInfo, options: options).decodeNil()
            if isNil {
                currentIndex += 1
            }
            return isNil
        }
        
        func decode<T>(_ type: T.Type) throws -> T where T : Decodable {
            defer { currentIndex += 1 }
            return try SingleValueContainer(json: json[currentIndex], codingPath: codingPath, userInfo: userInfo, options: options).decode(type)
        }
        
        func nestedContainer<NestedKey>(keyedBy type: NestedKey.Type) throws -> KeyedDecodingContainer<NestedKey> where NestedKey : CodingKey {
            defer { currentIndex += 1 }
            return KeyedDecodingContainer(KeyedContainer<NestedKey>(json: json[currentIndex], codingPath: codingPath, userInfo: userInfo, options: options))
        }
        
        func nestedUnkeyedContainer() throws -> UnkeyedDecodingContainer {
            defer { currentIndex += 1}
            return UnkeyedContainer(json: json[currentIndex], codingPath: codingPath, userInfo: userInfo, options: options)
        }
        
        func superDecoder() throws -> Decoder {
            throw JSON.Decoder.Error.superclassStructureConflict
        }
    }
}

// The "SingleValueContainer"s job is to read the appropriate data for an arbitrary type. If the type is not simple, it will dispatch a new decoder and attempt to decode into that type recursively, and read that output value.

extension JSONInternalDecoder {
    
    class SingleValueContainer: SingleValueDecodingContainer {
        
        let json: JSON
        let codingPath: [CodingKey]
        let userInfo: [CodingUserInfoKey: Any]
        let options: JSON.Decoder.Options
        
        init(json: JSON, codingPath: [CodingKey], userInfo: [CodingUserInfoKey: Any], options: JSON.Decoder.Options) {
            self.json = json
            self.codingPath = codingPath
            self.userInfo = userInfo
            self.options = options
        }
        
        func decodeNil() -> Bool {
            if case .null = json.internalValue {
                return true
            } else {
                return false
            }
        }
        
        func decode<T>(_ type: T.Type) throws -> T where T : Decodable {
            switch type {
            case is Bool.Type: return try convertDecoded(json.internalValue.truthy, to: type)
            case is String.Type: return try convertDecoded(try decodeString(), to: type)
            case is Double.Type: return try convertDecoded(try decodeNumber(), to: type)
            case is Float.Type: return try convertDecoded(Float(try decodeNumber()), to: type)
            case is Int.Type: return try convertDecoded(Int(try decodeNumber()), to: type)
            case is Int8.Type: return try convertDecoded(Int8(try decodeNumber()), to: type)
            case is Int16.Type: return try convertDecoded(Int16(try decodeNumber()), to: type)
            case is Int32.Type: return try convertDecoded(Int32(try decodeNumber()), to: type)
            case is Int64.Type: return try convertDecoded(Int64(try decodeNumber()), to: type)
            case is UInt.Type: return try convertDecoded(UInt(try decodeNumber()), to: type)
            case is UInt8.Type: return try convertDecoded(UInt8(try decodeNumber()), to: type)
            case is UInt16.Type: return try convertDecoded(UInt16(try decodeNumber()), to: type)
            case is UInt32.Type: return try convertDecoded(UInt32(try decodeNumber()), to: type)
            case is UInt64.Type: return try convertDecoded(UInt64(try decodeNumber()), to: type)
            default:
                let decoder = JSONInternalDecoder(json: json, codingPath: codingPath, userInfo: userInfo, options: options)
                return try type.init(from: decoder)
            }
        }
        
        func decodeNumber() throws -> Double {
            if let value = json.internalValue.doubleValue {
                return value
            } else {
                throw JSON.Decoder.Error.decodingNaN
            }
        }
        
        func decodeString() throws -> String {
            return try decodeString(using: options.stringParsingOptions.strategy(for: json.type))
        }
        
        func decodeString(using strategy: JSON.Decoder.StringParsingStrategy) throws -> String {
            switch strategy {
            case .asStringValue: return json.internalValue.stringValue
            case .asEmpty: return ""
            case .error: throw JSON.Decoder.Error.decodingStringWithInvalidData
            }
        }
        
        func convertDecoded<V, T>(_ value: V, to type: T.Type) throws -> T {
            guard let converted = value as? T else { throw JSON.Decoder.Error.unexpectedConversion }
            return converted
        }
    }
}
