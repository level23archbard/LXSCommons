//
//  Icons.swift
//  LXSCommons
//
//  Created by Alex Rote on 3/6/22.
//

import SwiftUI

// Steps to create icons
// 1. Go to https://editor.method.ac/ and create the icon
// 2. Save the icon to the assets folder
// 3. Fix the icon's colors to refer to "black" and fix the svg viewport (add "viewport"="0 0 24 24" to the root)
// 4. Add to the Icons.xcassets, set to Template/SingleScale, and add another entry below

public extension Image {
    
    static let add = Image("Add", bundle: Bundle.module)
    static let back = Image("Back", bundle: Bundle.module)
    static let check = Image("Check", bundle: Bundle.module)
    static let close = Image("Close", bundle: Bundle.module)
    static let collapse = Image("Collapse", bundle: Bundle.module)
    static let delete = Image("Delete", bundle: Bundle.module)
    static let expand = Image("Expand", bundle: Bundle.module)
    static let forward = Image("Forward", bundle: Bundle.module)
    static let question = Image("Question", bundle: Bundle.module)
    static let quill = Image("Quill", bundle: Bundle.module)
}
