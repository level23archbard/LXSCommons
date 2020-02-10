//
//  Extensions.swift
//  LXSCommons
//
//  Created by Alex Rote on 2/9/20.
//

public extension Bool {
    
    static func random(probability: Probability) -> Bool {
        return Bool.random(with: Random.Binary(p: probability))
    }
    
    static func random(with generator: RandomBoolGenerator) -> Bool {
        return generator.bool()
    }
}
