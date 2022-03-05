//
//  NodeStackNavigationController.swift
//  LXSCommons
//
//  Created by Alex Rote on 3/5/22.
//

import SwiftUI

// A lot of the core stacking interaction is based off of the work here: https://github.com/matteopuc/swiftui-navigation-stack

/// Node Stack Navigation Controller is made available through environment objects. Accepts push and pop calls to trigger navigations.
public final class NodeStackNavigationController: ObservableObject {
    
    let stack = ControllerStackHolder()
    let details = ControllerNodeDetailsHolder()
    
    public func push<V: View>(_ nextView: V) {
        stack.transitionType = .push
        withAnimation(stack.transitionType.animation) {
            stack.views.append(AnyView(nextView))
            details.currentDetails = nil
        }
    }
    
    public func pop() {
        guard !stack.views.isEmpty else { return }
        stack.transitionType = .pop
        withAnimation(stack.transitionType.animation) {
            _ = stack.views.removeLast()
            details.currentDetails = nil
        }
    }
    
    func updateNodeDetails(_ nodeDetails: NodeDetails) {
        details.currentDetails = nodeDetails
    }
}

// Transition Type enum, push/pop and related transition/animation constants
enum TransitionType {
    case push
    case pop
    
    var transition: AnyTransition {
        switch self {
        case .push:
            return AnyTransition.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading))
        case .pop:
            return AnyTransition.asymmetric(insertion: .move(edge: .leading), removal: .move(edge: .trailing))
        }
    }
    
    var animation: Animation {
        return Animation.easeOut(duration: 0.3)
    }
}

// Independently-observable object that holds the stack and current view. Stack is initial + ...views, so always has at least one entry. Initial is held in the StackHostView.
final class ControllerStackHolder: ObservableObject {
    
    @Published var currentView: AnyView?
    var views: [AnyView] = [] {
        didSet {
            currentView = views.last
        }
    }
    var transitionType = TransitionType.push
}

// Independently-observable object that holds the current node details.
final class ControllerNodeDetailsHolder: ObservableObject {
    @Published var currentDetails: NodeDetails?
}
