//
//  LosslessStringConvertible.swift
//  LXSCommons
//
//  Created by Alex Rote on 7/10/22.
//

extension JSON: LosslessStringConvertible {
    
    public init?(_ description: String) {
        if let json = try? JSON.parse(description) {
            self = json
        } else {
            return nil
        }
    }
    
    public var description: String {
        return JSON.stringify(self)
    }
}
