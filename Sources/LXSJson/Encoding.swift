//
//  Encoding.swift
//  LXSCommons
//
//  Created by Alex Rote on 11/13/21.
//  Copyright © 2021 Alex Rote. All rights reserved.
//

extension JSON {
    
    /// The JSON.Encoder acts similarly to the standard JSONEncoder, except it converts the codable item into a JSON struct as opposed to an immutable data.
    public struct Encoder {
        
        /// Creates a new Encoder.
        public init() {}
        
        /// Encode the value into an appropriate JSON struct, as opposed to an immutable data.
        public func encode<T: Encodable>(_ value: T) throws -> JSON {
            let encoder = JSONInternalEncoder()
            try value.encode(to: encoder)
            return try encoder.makeJson()
        }
        
        /// A possible encoding error that can occur while encoding a value into a JSON struct.
        public enum Error: Swift.Error {
            /// A superclass has defined a conflicting structure to a subclass. This can occur when a subclass or superclass implements a nondefault encode method and utilizes a different container.
            case superclassStructureConflict
            /// A superclass has defined a conflicting key from a subclass. This can occur when both a subclass and a superclass define their own property using the same name, and don't implement a custom coding key implementation for one of the properties.
            case superclassKeyConflict(key: String)
        }
    }
}

// This file will get a little busy. Here's how it's broken down. First, every container is responsible for tracking and collecting changes and creating a JSON output at the end, this protocol represents that.
fileprivate protocol JSONInternalEncoderContainer {
    func makeJson() throws -> JSON
}

// The "Encoder"s job is to serve as a first responder to an object's encode(to:) function, and usually just serves one purpose to dispatch a single, appropriate container that describes the object. It tracks that container and, at the finish, will consume the json from that container.
fileprivate class JSONInternalEncoder: Encoder, JSONInternalEncoderContainer {
    
    let codingPath: [CodingKey]
    let userInfo: [CodingUserInfoKey : Any]
    
    init(codingPath: [CodingKey] = [], userInfo: [CodingUserInfoKey: Any] = [:]) {
        self.codingPath = codingPath
        self.userInfo = userInfo
    }
        
    var container: JSONInternalEncoderContainer?
    
    func makeJson() throws -> JSON {
        return try container?.makeJson() ?? JSON()
    }
    
    func container<Key>(keyedBy type: Key.Type) -> KeyedEncodingContainer<Key> where Key : CodingKey {
        let container = KeyedContainer<Key>(codingPath: codingPath, userInfo: userInfo)
        self.container = container
        return KeyedEncodingContainer(container)
    }
    
    func unkeyedContainer() -> UnkeyedEncodingContainer {
        let container = UnkeyedContainer(codingPath: codingPath, userInfo: userInfo)
        self.container = container
        return container
    }
    
    func singleValueContainer() -> SingleValueEncodingContainer {
        let container = SingleValueContainer(codingPath: codingPath, userInfo: userInfo)
        self.container = container
        return container
    }
}

// The "KeyedContainer"s job is to create JSON objects, by collecting keys and encoding things into them. For simplicity, all things are routed into the "SingleValueContainer" to determine appropriate values, except for explicit requests to create new containers. The end result will merge keys to the return of the generated containers.

extension JSONInternalEncoder {
    
    class KeyedContainer<Key: CodingKey>: KeyedEncodingContainerProtocol, JSONInternalEncoderContainer {
        
        let codingPath: [CodingKey]
        let userInfo: [CodingUserInfoKey: Any]
        
        init(codingPath: [CodingKey], userInfo: [CodingUserInfoKey: Any]) {
            self.codingPath = codingPath
            self.userInfo = userInfo
        }
        
        var local: [String: JSONInternalEncoderContainer] = [:]
        var merging: [JSONInternalEncoderContainer] = []
        func makeJson() throws -> JSON {
            var json: JSON = [:]
            for (key, value) in local {
                json[key] = try value.makeJson()
            }
            for content in merging {
                guard case let .object(contentJson) = try content.makeJson().internalType else { throw JSON.Encoder.Error.superclassStructureConflict }
                for (key, value) in contentJson {
                    guard !JSON.hasOwnProperty(json, property: key) else { throw JSON.Encoder.Error.superclassKeyConflict(key: key) }
                    json[key] = value
                }
            }
            return json
        }
        
        func encodeNil(forKey key: Key) throws {
            let content = SingleValueContainer(codingPath: codingPath, userInfo: userInfo)
            try content.encodeNil()
            local[key.stringValue] = content
        }
        
        func encode<T>(_ value: T, forKey key: Key) throws where T : Encodable {
            let content = SingleValueContainer(codingPath: codingPath, userInfo: userInfo)
            try content.encode(value)
            local[key.stringValue] = content
        }
        
        func nestedContainer<NestedKey>(keyedBy keyType: NestedKey.Type, forKey key: Key) -> KeyedEncodingContainer<NestedKey> where NestedKey : CodingKey {
            let content = KeyedContainer<NestedKey>(codingPath: codingPath + [key], userInfo: userInfo)
            local[key.stringValue] = content
            return KeyedEncodingContainer(content)
        }
        
        func nestedUnkeyedContainer(forKey key: Key) -> UnkeyedEncodingContainer {
            let content = UnkeyedContainer(codingPath: codingPath, userInfo: userInfo)
            local[key.stringValue] = content
            return content
        }
        
        func superEncoder() -> Encoder {
            let content = JSONInternalEncoder(codingPath: codingPath, userInfo: userInfo)
            merging.append(content)
            return content
        }
        
        func superEncoder(forKey key: Key) -> Encoder {
            let content = JSONInternalEncoder(codingPath: codingPath + [key], userInfo: userInfo)
            local[key.stringValue] = content
            return content
        }
        
        func encodeIfPresentGeneric<T>(_ value: T?, forKey key: Key) throws where T : Encodable {
            if let value = value {
                try encode(value, forKey: key)
            } else {
                try encodeNil(forKey: key)
            }
        }
        
        func encodeIfPresent(_ value: Bool?, forKey key: Key) throws { try encodeIfPresentGeneric(value, forKey: key) }
        func encodeIfPresent(_ value: String?, forKey key: Key) throws { try encodeIfPresentGeneric(value, forKey: key) }
        func encodeIfPresent(_ value: Double?, forKey key: Key) throws { try encodeIfPresentGeneric(value, forKey: key) }
        func encodeIfPresent(_ value: Float?, forKey key: Key) throws { try encodeIfPresentGeneric(value, forKey: key) }
        func encodeIfPresent(_ value: Int?, forKey key: Key) throws { try encodeIfPresentGeneric(value, forKey: key) }
        func encodeIfPresent(_ value: Int8?, forKey key: Key) throws { try encodeIfPresentGeneric(value, forKey: key) }
        func encodeIfPresent(_ value: Int16?, forKey key: Key) throws { try encodeIfPresentGeneric(value, forKey: key) }
        func encodeIfPresent(_ value: Int32?, forKey key: Key) throws { try encodeIfPresentGeneric(value, forKey: key) }
        func encodeIfPresent(_ value: Int64?, forKey key: Key) throws { try encodeIfPresentGeneric(value, forKey: key) }
        func encodeIfPresent(_ value: UInt?, forKey key: Key) throws { try encodeIfPresentGeneric(value, forKey: key) }
        func encodeIfPresent(_ value: UInt8?, forKey key: Key) throws { try encodeIfPresentGeneric(value, forKey: key) }
        func encodeIfPresent(_ value: UInt16?, forKey key: Key) throws { try encodeIfPresentGeneric(value, forKey: key) }
        func encodeIfPresent(_ value: UInt32?, forKey key: Key) throws { try encodeIfPresentGeneric(value, forKey: key) }
        func encodeIfPresent(_ value: UInt64?, forKey key: Key) throws { try encodeIfPresentGeneric(value, forKey: key) }
        func encodeIfPresent<T>(_ value: T?, forKey key: Key) throws where T : Encodable { try encodeIfPresentGeneric(value, forKey: key) }
    }
}

// The "UnkeyedContainer"s job is to create JSON arrays, by simply encoding things into a growing list. For simplicity, all things are routed into the "SingleValueContainer" to determine appropriate values, except for explicit requests to create new containers. The end result will list all generated containers in order.

extension JSONInternalEncoder {
    
    class UnkeyedContainer: UnkeyedEncodingContainer, JSONInternalEncoderContainer {
        
        let codingPath: [CodingKey]
        let userInfo: [CodingUserInfoKey: Any]
        
        init(codingPath: [CodingKey], userInfo: [CodingUserInfoKey: Any]) {
            self.codingPath = codingPath
            self.userInfo = userInfo
        }
        
        var local: [JSONInternalEncoderContainer] = []
        var merging: [JSONInternalEncoderContainer] = []
        
        func makeJson() throws -> JSON {
            var json: JSON = []
            var index = 0
            // Order is decided by us here. How do super/sub classes determine the order of merged elements, when trying to follow separation of concerns? They dont! (And this is a bad design to try and follow anyways!) So we enforce the order here, subclass items then superclass items (and ascending up the chain)
            for value in local {
                json[index] = try value.makeJson()
                index += 1
            }
            for content in merging {
                guard case let .array(contentJson) = try content.makeJson().internalType else { throw JSON.Encoder.Error.superclassStructureConflict }
                for value in contentJson {
                    json[index] = value
                    index += 1
                }
            }
            return json
        }
        
        var count: Int {
            return merging.reduce(local.count, { total, next in
                if case let .array(contentJson) = try? next.makeJson().internalType {
                    return total + contentJson.count
                } else {
                    return total
                }
            })
        }
        
        func encodeNil() throws {
            let content = SingleValueContainer(codingPath: codingPath, userInfo: userInfo)
            try content.encodeNil()
            local.append(content)
        }
        
        func encode<T>(_ value: T) throws where T : Encodable {
            let content = SingleValueContainer(codingPath: codingPath, userInfo: userInfo)
            try content.encode(value)
            local.append(content)
        }
        
        func nestedContainer<NestedKey>(keyedBy keyType: NestedKey.Type) -> KeyedEncodingContainer<NestedKey> where NestedKey : CodingKey {
            let content = KeyedContainer<NestedKey>(codingPath: codingPath, userInfo: userInfo)
            local.append(content)
            return KeyedEncodingContainer(content)
        }
        
        func nestedUnkeyedContainer() -> UnkeyedEncodingContainer {
            let content = UnkeyedContainer(codingPath: codingPath, userInfo: userInfo)
            local.append(content)
            return content
        }
        
        func superEncoder() -> Encoder {
            let content = JSONInternalEncoder(codingPath: codingPath, userInfo: userInfo)
            merging.append(content)
            return content
        }
    }
}

// The "SingleValueContainer"s job is to determine the appropriate data for an arbitrary thing. If the value is not simple, it will dispatch a new encoder to the value and attempt to encode it recursively, and write that output to json. This container can always be expected to hold a completed json entry at its node.

extension JSONInternalEncoder {
    
    class SingleValueContainer: SingleValueEncodingContainer, JSONInternalEncoderContainer {
        
        let codingPath: [CodingKey]
        let userInfo: [CodingUserInfoKey: Any]
        
        init(codingPath: [CodingKey], userInfo: [CodingUserInfoKey: Any]) {
            self.codingPath = codingPath
            self.userInfo = userInfo
        }
        
        var json: JSON = JSON()
        
        func makeJson() throws -> JSON {
            return json
        }
        
        func encodeNil() throws {
            json.internalType = .null
        }
        
        func encode<T>(_ value: T) throws where T : Encodable {
            switch value {
            case let v as Bool: json.internalType = .boolean(v)
            case let v as String: json.internalType = .string(v)
            case let v as Double: json.internalType = .number(v)
            case let v as Float: json.internalType = .number(Double(v))
            case let v as Int: json.internalType = .number(Double(v))
            case let v as Int8: json.internalType = .number(Double(v))
            case let v as Int16: json.internalType = .number(Double(v))
            case let v as Int32: json.internalType = .number(Double(v))
            case let v as Int64: json.internalType = .number(Double(v))
            case let v as UInt: json.internalType = .number(Double(v))
            case let v as UInt8: json.internalType = .number(Double(v))
            case let v as UInt16: json.internalType = .number(Double(v))
            case let v as UInt32: json.internalType = .number(Double(v))
            case let v as UInt64: json.internalType = .number(Double(v))
            default:
                let encoder = JSONInternalEncoder(codingPath: codingPath, userInfo: userInfo)
                try value.encode(to: encoder)
                json = try encoder.makeJson()
            }
        }
    }
}
