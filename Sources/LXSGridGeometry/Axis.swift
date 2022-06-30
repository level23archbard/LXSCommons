//
//  Axis.swift
//  LXSCommons
//
//  Created by Alex Rote on 6/29/22.
//

/// A representation of the an axis along a grid geometry.
public enum Axis: Hashable {
    /// The x axis of a grid geometry. This typically represents one row in a grid, spanning across several columns.
    case x
    /// The y axis of a grid geometry. This typically represents one column in a grid, spanning across several rows.
    case y
    
    /// Gets the axis perpendicular to this axis.
    var perpendicularAxis: Axis {
        switch self {
        case .x: return .y
        case .y: return .x
        }
    }
}
