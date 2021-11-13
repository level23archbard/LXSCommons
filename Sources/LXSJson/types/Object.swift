//
//  Object.swift
//  LXSCommons
//
//  Created by Alex Rote on 11/10/21.
//  Copyright © 2021 Alex Rote. All rights reserved.
//

extension JSON: ExpressibleByDictionaryLiteral {
    
    // Note that, like javascript, duplicate keys will overwrite using last-wins. Also, be aware that Swift dictionary literal is square-brackets, not curly-brackets as in javascript!
    public init(dictionaryLiteral elements: (String, JSON)...) {
        var obj = [String: JSON]()
        for (key, value) in elements {
            obj[key] = value
        }
        internalType = .object(obj)
    }
}
