//
//  Version.swift
//  LXSCommons
//
//  Created by Alex Rote on 11/22/21.
//

/// A version structure loosely based on semver but allowing partial values, e.g. version 1, version 1.0, and version 1.0.0. The primary way to work with versions is to compare them against "support ranges", or ranges that specify an upper and lower bounds. Within this context, version can semantically compare. Unsafe behavior and possible crashes can occur if ranges are created with unequal lower and upper boundaries, create them carefully! When using semantic versions, remember that specific versions, i.e. version of an artifact, should be as precise as possible, and support versions, i.e. versions that make up a range, should be as open as possible.
public struct Version {
    
    private let components: [UInt]
        
    /// Creates a new version of a provided value.
    public init?<S: StringProtocol>(value: S) {
        guard !value.isEmpty else { return nil }
        var value = String(value)
        if value.starts(with: "v") || value.starts(with: "V") {
            value = String(value.dropFirst())
        }
        let stringComponents = value.components(separatedBy: ".")
        let numberComponents = stringComponents.compactMap { UInt($0) }
        guard stringComponents.count == numberComponents.count else { return nil }
        components = numberComponents
    }
    
    /// Creates a new version with a set of values.
    public init(value majorValue: UInt, _ minorValue: UInt? = nil, _ patchValue: UInt? = nil) {
        var components = [majorValue]
        if let minorValue = minorValue {
            components.append(minorValue)
        }
        if let patchValue = patchValue {
            if components.count < 2 { components.append(0) }
            components.append(patchValue)
        }
        self.components = components
    }
    
    /// Gets the major value of the version.
    public var majorValue: UInt { components[0] }
    
    /// Gets the minor value of the version, if present.
    public var minorValue: UInt? { value(at: 1) }
    
    /// Gets the patch value of the version, if present.
    public var patchValue: UInt? { value(at: 2) }
    
    /// Returns the number of components in the version.
    public var count: Int { components.count }
    
    /// Returns the value of the version at the component index, if present.
    public func value(at index: Int) -> UInt? {
        return components.count > index ? components[index] : nil
    }
}

extension Version: LosslessStringConvertible, CustomDebugStringConvertible {
    
    public init?(_ description: String) {
        self.init(value: description)
    }
    
    public var description: String {
        return components.map { String($0) }.joined(separator: ".")
    }
    
    public var debugDescription: String { description }
}

extension Version: ExpressibleByStringLiteral {
    
    // Version supports expressible by string literal using static strings, without optional unwrap. It is a programming error to create invalid strings in this manner!
    public init(stringLiteral value: StaticString) {
        self.init(value: String(value))!
    }
}

extension Version: Hashable {
    // Versions are going to be strictly equatable. Thus, 1.2 != 1.2.0. This should make sense because 1.2 identifies a different set of patches then 1.2.0.
}

extension Version: Comparable {
    
    // Versions compare strictly and without context, as A < B must imply that B > A. This means for shared lengths, 1.2 < 1.3. For non-shared lengths, though, results can seem a bit strange, for example 1.2 > 1.2.1. This is because the unknown patch after 1.2 must strictly be interpreted as the latest possible patch.
    
    private func normalizedCeilingComponents(to count: Int) -> [UInt] {
        if components.count < count {
            return components + Array(repeating: UInt.max, count: count - components.count)
        } else {
            return components
        }
    }
    
    private func normalizedFloorComponents(to count: Int) -> [UInt] {
        if components.count < count {
            return components + Array(repeating: 0, count: count - components.count)
        } else {
            return components
        }
    }
    
    private func truncatedComponents(to count: Int) -> [UInt] {
        if components.count > count {
            return Array(components[..<count])
        } else {
            return components
        }
    }
    
    public static func < (lhs: Version, rhs: Version) -> Bool {
        return lhs.isLower(than: rhs)
    }
    
    // In the context of ranges, where a version can be defined as a lower or upper bound, versions can compare in a way that makes much more sense. The following functions will define those relations, and extensions to Range structures with Versions will utilize these.
    
    /// Compares whether this version is semantically lower than the other version. This may be more clearly read as, compares whether this version is less than the greatest possible representation of the other version. For example, 1.2 is lower than 1.3, 1.2 is not lower than 1.1, 1.2 is lower than 1, 1.2 is lower than 2, and 1.2 is not lower than 1.2.0. isLower is not reflective, i.e. 1.2 is not lower than 1.2.
    public func isLower(than otherVersion: Version) -> Bool {
        let maxCount = max(components.count, otherVersion.components.count)
        for (left, right) in zip(normalizedCeilingComponents(to: maxCount), otherVersion.normalizedCeilingComponents(to: maxCount)) {
            if left < right { return true }
            if left > right { return false }
        }
        return false
    }
    
    /// Compares whether this version is semantically higher than the other version. This may be more clearly read as, compares whether this version is greater than the lowest possible representation of the other version. For exmaple, 1.2 is not higher than 1.3, 1.2 is higher than 1.1, 1.2 is higher than 1, 1.2 is not higher than 2, and 1.2 is not higher than 1.2.0. isHigher is not reflective, i.e. 1.2 is not higher than 1.2
    public func isHigher(than otherVersion: Version) -> Bool {
        let maxCount = max(components.count, otherVersion.components.count)
        for (left, right) in zip(normalizedFloorComponents(to: maxCount), otherVersion.normalizedFloorComponents(to: maxCount)) {
            if left < right { return false }
            if left > right { return true }
        }
        return false
    }
    
    /// Compares whether this version is sematically within the other version. This may be more clearly read as, checks whether this version could be represented by the other version. For example, 1.2 is not within 1.3, 1.2 is not within 1.1, 1.2 is within 1, 1.2 is not within 2, and 1.2 is within 1.2.0. isWithin is reflective, i.e. 1.2 is within 1.2.
    public func isWithin(_ otherVersion: Version) -> Bool {
        let minCount = min(components.count, otherVersion.components.count)
        return truncatedComponents(to: minCount) == otherVersion.truncatedComponents(to: minCount)
    }
    
    public func isBounded(by bounds: Range<Self>) -> Bool {
        return bounds.contains(self)
    }
    
    public func isBounded(by bounds: ClosedRange<Self>) -> Bool {
        return bounds.contains(self)
    }
    
    public func isBounded(by bounds: PartialRangeFrom<Self>) -> Bool {
        return bounds.contains(self)
    }
    
    public func isBounded(by bounds: PartialRangeUpTo<Self>) -> Bool {
        return bounds.contains(self)
    }
    
    public func isBounded(by bounds: PartialRangeThrough<Self>) -> Bool {
        return bounds.contains(self)
    }
}

// Putting isHigher and isLower together, ranges check whether a version is higher than the lower bound and is lower than the higher bound. A range's closed boundaries also check if the version is within the bound.
// BE AWARE THAT VERSION RANGES SHOULD ALWAYS BE CREATED USING IDENTICAL COMPONENT LENGTHS!

extension Range where Bound == Version {
    public func contains(_ element: Version) -> Bool {
        return (element.isWithin(lowerBound) || element.isHigher(than: lowerBound)) && element.isLower(than: upperBound)
    }
}

extension ClosedRange where Bound == Version {
    public func contains(_ element: Version) -> Bool {
        return (element.isWithin(lowerBound) || element.isHigher(than: lowerBound)) && (element.isWithin(upperBound) || element.isLower(than: upperBound))
    }
}

extension PartialRangeFrom where Bound == Version {
    public func contains(_ element: Version) -> Bool {
        return element.isWithin(lowerBound) || element.isHigher(than: lowerBound)
    }
}

extension PartialRangeUpTo where Bound == Version {
    public func contains(_ element: Version) -> Bool {
        return element.isLower(than: upperBound)
    }
}

extension PartialRangeThrough where Bound == Version {
    public func contains(_ element: Version) -> Bool {
        return element.isWithin(upperBound) || element.isLower(than: upperBound)
    }
}

extension Version: Codable {
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let string = try container.decode(String.self)
        guard let version = Version(value: string) else { throw DecodingError.dataCorruptedError(in: container, debugDescription: "\(string) does not parse to a valid version.") }
        self = version
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(description)
    }
}
