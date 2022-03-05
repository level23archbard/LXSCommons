//
//  StackHost.swift
//  LXSCommons
//
//  Created by Alex Rote on 3/5/22.
//

import SwiftUI

// Stack Host holds the stacked views
struct StackHost<InitialView: View>: View {
    
    @EnvironmentObject private var controller: ControllerStackHolder
    
    private var content: () -> InitialView
    
    init(content: @escaping () -> InitialView) {
        self.content = content
    }
    
    var body: some View {
        // These lines are more or less magic, changing them even slightly results in the entire animations failure. This "if" is especially, magically important for some reason
        return ZStack {
            Group {
                if let currentView = controller.currentView {
                    currentView
                        .transition(controller.transitionType.transition)
                } else {
                    content()
                        .transition(controller.transitionType.transition)
                }
            }
        }
    }
}
