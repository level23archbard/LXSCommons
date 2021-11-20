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
            let decoder = JSONInternalDecoder(json: json)
            return try type.init(from: decoder)
        }
        
        /// A possible decoding error that can occur while decoding a type from a JSON struct.
        public enum Error: Swift.Error {
            /// A non-number attempted to decode into a number.
            case decodingNaN
            /// An unexpected type conversion occurred during value decoding. This should not happen, but may indicate an unusual type attempted to decode a standard JSON data, which is not allowed.
            case unexpectedConversion
            /// A superclass has defined a conflicting structure to a subclass. This can occur when an unkeyed subclass and superclass compete for the same resource.
            case superclassStructureConflict
        }
    }
}

// This file is a bit less busy than Encoding, but still broken down about the same.

// The "Decoder"s job is to serve as a first responder to an object's init(from:) function, and usually just serves one purpose to dispatch a single, appropriate container that describes the object. After dispatch, the decoder is unused.
fileprivate class JSONInternalDecoder: Decoder {
    
    let json: JSON
    let codingPath: [CodingKey]
    let userInfo: [CodingUserInfoKey: Any]
    
    init(json: JSON, codingPath: [CodingKey] = [], userInfo: [CodingUserInfoKey: Any] = [:]) {
        self.json = json
        self.codingPath = codingPath
        self.userInfo = userInfo
    }
    
    func container<Key>(keyedBy type: Key.Type) throws -> KeyedDecodingContainer<Key> where Key : CodingKey {
        return KeyedDecodingContainer(KeyedContainer<Key>(json: json, codingPath: codingPath, userInfo: userInfo))
    }
    
    func unkeyedContainer() throws -> UnkeyedDecodingContainer {
        return UnkeyedContainer(json: json, codingPath: codingPath, userInfo: userInfo)
    }
    
    func singleValueContainer() throws -> SingleValueDecodingContainer {
        return SingleValueContainer(json: json, codingPath: codingPath, userInfo: userInfo)
    }
}

// The "KeyedContainer"s job is to read JSON objects. For simplicity, all values are routed into the "SingleValueContainer" to determine appropriate values, except for explicit requests to create new containers.

extension JSONInternalDecoder {
    
    class KeyedContainer<Key: CodingKey>: KeyedDecodingContainerProtocol {
        
        let json: JSON
        let codingPath: [CodingKey]
        let userInfo: [CodingUserInfoKey: Any]
        
        init(json: JSON, codingPath: [CodingKey], userInfo: [CodingUserInfoKey: Any]) {
            self.json = json
            self.codingPath = codingPath
            self.userInfo = userInfo
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
            return SingleValueContainer(json: json[key.stringValue], codingPath: codingPath, userInfo: userInfo).decodeNil()
        }
        
        func decode<T>(_ type: T.Type, forKey key: Key) throws -> T where T : Decodable {
            return try SingleValueContainer(json: json[key.stringValue], codingPath: codingPath, userInfo: userInfo).decode(type)
        }
        
        func nestedContainer<NestedKey>(keyedBy type: NestedKey.Type, forKey key: Key) throws -> KeyedDecodingContainer<NestedKey> where NestedKey : CodingKey {
            return KeyedDecodingContainer(KeyedContainer<NestedKey>(json: json[key.stringValue], codingPath: codingPath + [key], userInfo: userInfo))
        }
        
        func nestedUnkeyedContainer(forKey key: Key) throws -> UnkeyedDecodingContainer {
            return UnkeyedContainer(json: json[key.stringValue], codingPath: codingPath + [key], userInfo: userInfo)
        }
        
        func superDecoder() throws -> Decoder {
            return JSONInternalDecoder(json: json, codingPath: codingPath, userInfo: userInfo)
        }
        
        func superDecoder(forKey key: Key) throws -> Decoder {
            return JSONInternalDecoder(json: json[key.stringValue], codingPath: codingPath + [key], userInfo: userInfo)
        }
    }
}

// The "UnkeyedContainer"s job is to read JSON arrays. For simplicity, all things are routed into the "SingleValueContainer" to determine appropriate values, except for explicit requests to create new containers. Order is tracked, and hence competing for the same container resource between subclass and superclass is not allowed.

extension JSONInternalDecoder {
    
    class UnkeyedContainer: UnkeyedDecodingContainer {
        
        let json: JSON
        let codingPath: [CodingKey]
        let userInfo: [CodingUserInfoKey: Any]
        
        init(json: JSON, codingPath: [CodingKey], userInfo: [CodingUserInfoKey: Any]) {
            self.json = json
            self.codingPath = codingPath
            self.userInfo = userInfo
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
            let isNil = SingleValueContainer(json: json[currentIndex], codingPath: codingPath, userInfo: userInfo).decodeNil()
            if isNil {
                currentIndex += 1
            }
            return isNil
        }
        
        func decode<T>(_ type: T.Type) throws -> T where T : Decodable {
            defer { currentIndex += 1 }
            return try SingleValueContainer(json: json[currentIndex], codingPath: codingPath, userInfo: userInfo).decode(type)
        }
        
        func nestedContainer<NestedKey>(keyedBy type: NestedKey.Type) throws -> KeyedDecodingContainer<NestedKey> where NestedKey : CodingKey {
            defer { currentIndex += 1 }
            return KeyedDecodingContainer(KeyedContainer<NestedKey>(json: json[currentIndex], codingPath: codingPath, userInfo: userInfo))
        }
        
        func nestedUnkeyedContainer() throws -> UnkeyedDecodingContainer {
            defer { currentIndex += 1}
            return UnkeyedContainer(json: json[currentIndex], codingPath: codingPath, userInfo: userInfo)
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
        
        init(json: JSON, codingPath: [CodingKey], userInfo: [CodingUserInfoKey: Any]) {
            self.json = json
            self.codingPath = codingPath
            self.userInfo = userInfo
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
            case is String.Type: return try convertDecoded(json.internalValue.stringValue, to: type)
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
                let decoder = JSONInternalDecoder(json: json)
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
        
        func convertDecoded<V, T>(_ value: V, to type: T.Type) throws -> T {
            guard let converted = value as? T else { throw JSON.Decoder.Error.unexpectedConversion }
            return converted
        }
    }
}
