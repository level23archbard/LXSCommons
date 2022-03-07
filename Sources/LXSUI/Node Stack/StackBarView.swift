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
                    action.0.makeButton(action: action.1)
                }
            }
            .frame(height: barHeight)
            .padding(.top, topSafeArea)
        }
    }
}

fileprivate extension NodeDetailsButtonType {
    
    func makeButton(action: @escaping () -> ()) -> some View {
        switch self {
        case .text(let text):
            return AnyView(StackBarTextButton(action: action, text: text))
        case .icon(let icon):
            return AnyView(StackBarIconButton(action: action, icon: icon))
        }
    }
}

fileprivate struct StackBarIconButton: View {
    
    @Environment(\.themeSecondaryColor) private var color: Color
    
    let action: () -> ()
    let icon: Image
    
    init(action: @escaping () -> (), icon: Image) {
        self.action = action
        self.icon = icon
    }
    
    var body: some View {
        Button(action: action) {
            icon
            .frame(width: 20, height: 20)
            .padding(6)
        }
        .foregroundColor(color)
    }
}

fileprivate struct StackBarTextButton: View {
    
    @Environment(\.themeSecondaryColor) private var color: Color
    
    let action: () -> ()
    let text: String
    
    init(action: @escaping () -> (), text: String) {
        self.action = action
        self.text = text
    }
    
    var body: some View {
        Button(text, action: action)
        .foregroundColor(color)
    }
}

fileprivate struct StackBarBackButton: View {
    
    @Environment(\.themeSecondaryColor) private var color: Color
    @EnvironmentObject private var controller: NodeStackNavigationController
    
    var body: some View {
        StackBarIconButton(action: {
            controller.pop()
        }, icon: .back)
    }
}

fileprivate struct StackBarTitle: View {
    
    @Environment(\.themeSecondaryColor) private var color: Color
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
                .foregroundColor(color))
        } else {
            return AnyView(EmptyView())
        }
    }
}
