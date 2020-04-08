//
//  DataExtensions.swift
//  LXSCommons
//
//  Created by Alex Rote on 2/11/20.
//

import Foundation

public extension Data {
    
    func hexEncodedString() -> String {
        let hexEncodedString = map { String(format: "%02X", $0) }.reduce("", +)
        return "<" + hexEncodedString + ">"
    }
    
    init?(hexEncodedString: String) {
        var startIndex = hexEncodedString.startIndex
        var endIndex = hexEncodedString.endIndex
        if hexEncodedString.first == "<" {
            startIndex = hexEncodedString.index(after: startIndex)
            guard hexEncodedString.last == ">" else {
                return nil
            }
            endIndex = hexEncodedString.index(before: endIndex)
        }
        let hexEncodedString = hexEncodedString[startIndex..<endIndex]
        
        var buffer = Data()
        var prevChar: Character?
        for character in hexEncodedString {
            guard character.isHexDigit || character.isWhitespace else {
                return nil
            }
            if let prevCharacter = prevChar {
                guard character.isHexDigit else {
                    return nil
                }
                buffer.append(UInt8(prevCharacter.hexDigitValue! * 16 + character.hexDigitValue!))
                prevChar = nil
            } else {
                if !character.isHexDigit {
                    continue
                }
                prevChar = character
            }
        }
        self = buffer
    }
}
