//
//  NodeStackView.swift
//  LXSCommons
//
//  Created by Alex Rote on 3/5/22.
//

import SwiftUI

/// The Node Stack View is a container that stacks new views on top of the initial content view, using a traditional NavigationView-like approach. The NodeStackView declares an environment object NodeStackNavigationController that can be used to initiate navigation between nodes through the stack.
public struct NodeStackView<InitialView: View>: View {
    
    // Instantiate the navigation stack to the inital view.
    @StateObject private var controller = NodeStackNavigationController()
    
    private var content: () -> InitialView
    
    /// Initializes a new Node Stack View with an initial view.
    public init(content: @escaping () -> InitialView) {
        self.content = content
    }
    
    public var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                StackBarView(topSafeArea: geometry.safeAreaInsets.top)
                StackHost(content: content)
                    .frame(maxHeight: .infinity)
            }
            .environmentObject(controller)
            .environmentObject(controller.stack)
            .environmentObject(controller.details)
            .frame(maxHeight: .infinity)
            .edgesIgnoringSafeArea(.top)
        }
    }
}
