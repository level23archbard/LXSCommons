//
//  Grid.swift
//  LXSCommons
//
//  Created by Alex Rote on 12/5/21.
//

/// The grid represents a fixed-size collection of items indexed by points. Indexing a grid assumes the point must exist in the grid, it is a programming error to index a grid with a point not included in the grid's rect.
public struct Grid<Element> {
    
    private var values: [Element]
    
    /// The rect of the grid, which describes the possible points that can index the grid.
    public let rect: Rect
    
    /// The size of the grid, which describes the size of the grid's rect.
    public var size: Size { rect.size }
    
    /// Creates a grid with the initial value configured to every point in the rect.
    public init(rect: Rect, initialValue: Element) {
        self.rect = rect
        self.values = Array(repeating: initialValue, count: rect.count)
    }
    
    /// Creates a grid with the initial value configured to every point in a rect of the given size.
    public init(size: Size, initialValue: Element) {
        self.init(rect: size.bounds, initialValue: initialValue)
    }
    
    // This indexing is equivalent to row by row indexing
    private func valuesIndex(from point: Point) -> Int {
        return (point.y - rect.minY) * abs(rect.width) + (point.x - rect.minX)
    }
    
    public subscript(point: Point) -> Element {
        get {
            guard rect.contains(point: point) else { fatalError("Invalid index of position \(point)") }
            return values[valuesIndex(from: point)]
        }
        set {
            guard rect.contains(point: point) else { fatalError("Invalid index of position \(point)") }
            values[valuesIndex(from: point)] = newValue
        }
    }
}

// MARK: - Mutable Collection

extension Grid: MutableCollection, RandomAccessCollection {
    
    /// The opaque collection index of a grid.
    public struct GridIndex: Strideable {
        fileprivate let index: Int
        fileprivate init(index: Int) {
            self.index = index
        }
        public func advanced(by n: Int) -> GridIndex {
            return GridIndex(index: index + n)
        }
        public func distance(to other: GridIndex) -> Int {
            return other.index - index
        }
    }
    
    public var startIndex: GridIndex {
        return GridIndex(index: 0)
    }
    
    public var endIndex: GridIndex {
        return GridIndex(index: values.count)
    }
    
    public func index(after i: GridIndex) -> GridIndex {
        return GridIndex(index: i.index + 1)
    }
    
    public func index(before i: GridIndex) -> GridIndex {
        return GridIndex(index: i.index - 1)
    }
    
    public subscript(position: GridIndex) -> Element {
        get {
            return values[position.index]
        }
        set {
            values[position.index] = newValue
        }
    }
}

// MutableCollection methods and properties that are overridden or duplicated to provide better support

public extension Grid {
    
    /// Exchanges the values at the specified points on the grid.
    mutating func swapAt(_ i: Point, _ j: Point) {
        guard rect.contains(point: i) && rect.contains(point: j) else { return }
        let val = self[i]
        self[i] = self[j]
        self[j] = val
    }
    
    /// Helper to construct the collection index, from a point. This can be useful for Collection extensions that rely on index values. Returns nil if the point is not contained in the grid.
    func index(from point: Point) -> GridIndex? {
        guard rect.contains(point: point) else { return nil }
        return GridIndex(index: valuesIndex(from: point))
    }
}

// MARK: - Equatable

extension Grid: Equatable where Element: Equatable {}
