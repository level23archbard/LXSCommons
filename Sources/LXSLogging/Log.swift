//
//  Log.swift
//  LXSCommons
//
//  Created by Alex Rote on 2/5/20.
//

/// Everything related to logging is wrapped in the top-level namespace "Log".
public enum Log {}

// MARK: - Log Levels

extension Log {
    
    public enum Level {
        case error
        case warning
        case info
        case custom(Int)
        case debug
        case verbose
    }
}

// MARK: - Comparing Levels

extension Log.Level: Comparable {
    
    private var approximateValue: Int {
        switch self {
        case .error: return 2
        case .warning: return 1
        case .info: return 0
        case .custom(_): return 0
        case .debug: return -1
        case .verbose: return -2
        }
    }
    
    public static func < (lhs: Log.Level, rhs: Log.Level) -> Bool {
        var lhsValue = lhs.approximateValue, rhsValue = rhs.approximateValue
        if lhsValue != rhsValue {
            return lhsValue < rhsValue
        }
        if case let .custom(level) = lhs {
            lhsValue = level
            if level == 0 && rhs == .info {
                return true // 0 < 0.5 == true
            }
        }
        if case let .custom(level) = rhs {
            rhsValue = level
            if level == 0 && lhs == .info {
                return false // 0.5 < 0 == false
            }
        }
        return lhsValue < rhsValue
    }
}

// MARK: - Simple Logging

extension Log {
    
    // Log String
    
    public static func error(_ message: String) {
        event(Event(level: .error, message))
    }
    
    public static func warning(_ message: String) {
        event(Event(level: .warning, message))
    }
    
    public static func info(_ message: String) {
        event(Event(level: .info, message))
    }
    
    public static func debug(_ message: String) {
        event(Event(level: .debug, message))
    }
    
    public static func verbose(_ message: String) {
        event(Event(level: .verbose, message))
    }
    
    // Log String Protocol
    
    public static func error<S: StringProtocol>(_ message: S) {
        event(Event(level: .error, message))
    }
    
    public static func warning<S: StringProtocol>(_ message: S) {
        event(Event(level: .warning, message))
    }

    public static func info<S: StringProtocol>(_ message: S) {
        event(Event(level: .info, message))
    }

    public static func debug<S: StringProtocol>(_ message: S) {
        event(Event(level: .debug, message))
    }

    public static func verbose<S: StringProtocol>(_ message: S) {
        event(Event(level: .verbose, message))
    }
    
    // Log Static String
    
    public static func error(_ message: StaticString) {
        event(Event(level: .error, message))
    }
    
    public static func warning(_ message: StaticString) {
        event(Event(level: .warning, message))
    }

    public static func info(_ message: StaticString) {
        event(Event(level: .info, message))
    }

    public static func debug(_ message: StaticString) {
        event(Event(level: .debug, message))
    }

    public static func verbose(_ message: StaticString) {
        event(Event(level: .verbose, message))
    }
    
    // Log Dynamic Messages
    
    public typealias DynamicString = () -> (String)
    
    public static func error(_ dynamicMessage: @escaping DynamicString) {
        event(Event(level: .error, dynamicMessage))
    }
    
    public static func warning(_ dynamicMessage: @escaping DynamicString) {
        event(Event(level: .warning, dynamicMessage))
    }
    
    public static func info(_ dynamicMessage: @escaping DynamicString) {
        event(Event(level: .info, dynamicMessage))
    }
    
    public static func debug(_ dynamicMessage: @escaping DynamicString) {
        event(Event(level: .debug, dynamicMessage))
    }
    
    public static func verbose(_ dynamicMessage: @escaping DynamicString) {
        event(Event(level: .verbose, dynamicMessage))
    }
}

// MARK: - Event Logging

extension Log {
    
    public struct Event {
        
        public init(level: Level, _ message: String) {
            self.level = level
            messageType = .simple(message)
        }
        
        public init<S: StringProtocol>(level: Level, _ typeableMessage: S) {
            self.init(level: level, String(typeableMessage))
        }
        
        public init(level: Level, _ staticMessage: StaticString) {
            self.init(level: level, staticMessage.withUTF8Buffer({
                String(decoding: $0, as: UTF8.self)
            }))
        }
        
        public init(level: Level, _ dynamicMessage: @escaping DynamicString) {
            self.level = level
            messageType = .dynamic(dynamicMessage)
        }
        
        internal enum MessageType {
            case simple(String)
            case dynamic(DynamicString)
        }
        internal var messageType: MessageType
        
        internal var level: Level
        
        internal mutating func read() -> String {
            switch messageType {
            case .simple(let message):
                return message
            case .dynamic(let message):
                let unwrap = message()
                messageType = .simple(unwrap)
                return unwrap
            }
        }
    }
    
    public static func event(_ event: Event) {
        var event = event
        switch event.level {
        case .error:
            #if DEBUG
            fatalError(event.read())
            #else
            print(event.read())
            #endif
        case .warning, .info, .custom(_):
            print(event.read())
        case .debug, .verbose:
            #if DEBUG
            print(event.read())
            #endif
        }
    }
}
