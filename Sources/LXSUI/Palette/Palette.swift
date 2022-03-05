//
//  Palette.swift
//  LXSCommons
//
//  Created by Alex Rote on 3/5/22.
//

import SwiftUI

/// A Palette defines a set of colors that can be defined in a common root and referred using environnment values.
public struct Palette {
    
    /// The theme palette is used to display special colors that relate to the UIs theme. These are typically saturated colors.
    public var theme: PaletteColor
    /// The stroke palette is used to display text or icon colors that should be read. These are typically de-saturated colors.
    public var stroke: PaletteColor
    /// The background palette is used to display backgrounds or canvases that should contain content. These are typically de-saturated colors.
    public var background: PaletteColor
    
    /// Creates a new Palette.
    public init(
        theme: PaletteColor = PaletteColor(primary: .accentColor, secondary: .white),
        stroke: PaletteColor = PaletteColor(primary: .primary, secondary: .secondary),
        background: PaletteColor = PaletteColor(primary: Color(uiColor: .systemBackground), secondary: Color(uiColor: .secondarySystemBackground))
    ) {
        self.theme = theme
        self.stroke = stroke
        self.background = background
    }
}

/// A Palette Color specifies a hierarchy of color options, noting fine-tuning of values as needed.
public struct PaletteColor {
    
    /// The primary color of the palette.
    public var primary: Color
    /// The secondary color of the palette.
    public var secondary: Color
    
    /// Creates a new Palette Color.
    public init(primary: Color, secondary: Color?) {
        self.primary = primary
        self.secondary = secondary ?? primary
    }
}

private struct PaletteKey: EnvironmentKey {
    static let defaultValue = Palette()
}

public extension EnvironmentValues {
    
    /// The current palette of colors.
    var palette: Palette {
        get { self[PaletteKey.self] }
        set { self[PaletteKey.self] = newValue }
    }
    
    /// The palette's primary theme color.
    var themePrimaryColor: Color {
        get { palette.theme.primary }
        set { palette.theme.primary = newValue }
    }
    
    /// The palette's secondary theme color.
    var themeSecondaryColor: Color {
        get { palette.theme.secondary }
        set { palette.theme.secondary = newValue }
    }
    
    /// The palette's primary stroke color.
    var strokePrimaryColor: Color {
        get { palette.stroke.primary }
        set { palette.stroke.primary = newValue }
    }
    
    /// The palette's secondary stroke color.
    var strokeSecondaryColor: Color {
        get { palette.stroke.secondary }
        set { palette.stroke.secondary = newValue }
    }
    
    /// The palette's primary background color.
    var backgroundPrimaryColor: Color {
        get { palette.background.primary }
        set { palette.background.primary = newValue }
    }
    
    /// The palette's secondary background color.
    var backgroundSecondaryColor: Color {
        get { palette.background.secondary }
        set { palette.background.secondary = newValue }
    }
}

public extension View {
    
    /// Declares the palette for the view's environment.
    func palette(_ value: Palette) -> some View {
        environment(\.palette, value)
    }
    
    /// Declares the palette's primary theme color for the view's environment.
    func themePrimaryColor(_ value: Color) -> some View {
        environment(\.themePrimaryColor, value)
    }
    
    /// Declares the palette's secondary theme color for the view's environment.
    func themeSecondaryColor(_ value: Color) -> some View {
        environment(\.themeSecondaryColor, value)
    }
    
    /// Declares the palette's primary stroke color for the view's environment.
    func strokePrimaryColor(_ value: Color) -> some View {
        environment(\.strokePrimaryColor, value)
    }
    
    /// Declares the palette's secondary stroke color for the view's environment.
    func strokeSecondaryColor(_ value: Color) -> some View {
        environment(\.strokeSecondaryColor, value)
    }
    
    /// Declares the palette's primary background color for the view's environment.
    func backgroundPrimaryColor(_ value: Color) -> some View {
        environment(\.backgroundPrimaryColor, value)
    }
    
    /// Declares the palette's secondary background color for the view's environment.
    func backgroundSecondaryColor(_ value: Color) -> some View {
        environment(\.backgroundSecondaryColor, value)
    }
}
