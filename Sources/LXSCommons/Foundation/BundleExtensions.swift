//
//  BundleExtensions.swift
//  LXSCommons
//
//  Created by Alex Rote on 12/8/19.
//

import Foundation

public extension Bundle {
    
    var bundleName: String? {
        return self.object(forInfoDictionaryKey: kCFBundleNameKey as String) as? String
    }
}
