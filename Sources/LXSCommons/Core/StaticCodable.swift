//
//  StaticCodable.swift
//  LXSCommons
//
//  Created by Alex Rote on 2/25/20.
//  Copyright © 2020 Alex Rote. All rights reserved.
//

public protocol StaticCodable: Codable, Identifiable, CaseIterable, Hashable, Comparable where ID: Codable { }

extension StaticCodable {
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let id = try container.decode(ID.self)
        if let instance = Self.allCases.first(where: { $0.id == id }) {
            self = instance
        } else {
            throw StaticCodableError.identifierNotRecognized
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(id)
    }
}

extension StaticCodable {
    
    public static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.id == rhs.id
    }
    
    public func hash(into hasher: inout Hasher) {
        id.hash(into: &hasher)
    }
}

extension StaticCodable {
    
    public static func < (lhs: Self, rhs: Self) -> Bool {
        guard let lIndex = Self.allCases.firstIndex(of: lhs), let rIndex = Self.allCases.firstIndex(of: rhs) else {
            fatalError()
        }
        return lIndex < rIndex
    }
}

public enum StaticCodableError: Error {
    case identifierNotRecognized
}
