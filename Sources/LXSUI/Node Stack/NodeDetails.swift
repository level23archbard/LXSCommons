//
//  NodeDetails.swift
//  LXSCommons
//
//  Created by Alex Rote on 3/5/22.
//

import SwiftUI

/// A set of details that describes the current node in the stack.
public struct NodeDetails {
    
    /// The title of the node.
    public var title: String?
    /// The right action button of the node.
    public var rightButtonAction: Optional<(String, () -> ())>
    
    /// Creates a new set of details.
    public init(title: String? = nil, rightButtonAction: Optional<(String, () -> ())> = nil) {
        self.title = title
        self.rightButtonAction = rightButtonAction
    }
}

/// A modifier that describes the current node in the stack.
public struct NodeDefinition: ViewModifier {
    
    @EnvironmentObject private var controller: NodeStackNavigationController
    
    /// The details associated with the modifier.
    public var details: NodeDetails
    
    /// Creates a new modifier.
    public init(_ details: NodeDetails) {
        self.details = details
    }
    
    public func body(content: Content) -> some View {
        controller.updateNodeDetails(details)
        return content.onAppear()
    }
}

public extension View {
    
    /// Declares the details of the current node in the stack.
    func nodeDefinition(_ details: NodeDetails) -> some View {
        modifier(NodeDefinition(details))
    }
}
