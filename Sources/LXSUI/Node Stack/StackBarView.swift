//
//  StackBarView.swift
//  LXSCommons
//
//  Created by Alex Rote on 3/5/22.
//

import SwiftUI

// The actual navigation bar view.
struct StackBarView: View {
    
    @Environment(\.themePrimaryColor) private var barFillColor: Color
    @Environment(\.themeSecondaryColor) private var barStrokeColor: Color
    @EnvironmentObject private var stack: ControllerStackHolder
    @EnvironmentObject private var details: ControllerNodeDetailsHolder
    
    // Needs to know its top safe area to render all layouts
    var topSafeArea: CGFloat
    // Constant bar height
    let barHeight: CGFloat = 44
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(barFillColor)
                .frame(height: barHeight + topSafeArea)
            HStack {
                if !stack.views.isEmpty {
                    StackBarBackButton()
                }
                Spacer()
                StackBarTitle()
                Spacer()
                if let action = details.currentDetails?.rightButtonAction {
                    Button(action.0, action: action.1)
                        .foregroundColor(barStrokeColor)
                }
            }
            .frame(height: barHeight)
            .padding(.top, topSafeArea)
        }
    }
}

fileprivate struct StackBarBackButton: View {
    
    @Environment(\.themeSecondaryColor) private var barStrokeColor: Color
    @EnvironmentObject private var controller: NodeStackNavigationController
    
    var body: some View {
        Button("Back") {
            controller.pop()
        }
        .foregroundColor(barStrokeColor)
    }
}

fileprivate struct StackBarTitle: View {
    
    @Environment(\.themeSecondaryColor) private var barStrokeColor: Color
    @EnvironmentObject private var details: ControllerNodeDetailsHolder
    
    var body: some View {
        let title: String?
        if let currentDetails = details.currentDetails {
            title = currentDetails.title
        } else {
            title = nil
        }
        if let title = title {
            return AnyView(Text(title)
                .foregroundColor(barStrokeColor))
        } else {
            return AnyView(EmptyView())
        }
    }
}
