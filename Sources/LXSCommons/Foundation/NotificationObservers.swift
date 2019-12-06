//
//  NotificationObservers.swift
//  LXSCommons
//
//  Created by Alex Rote on 7/7/18.
//  Copyright © 2018 Alex Rote. All rights reserved.
//

import Foundation

public class NotificationObservers {
    
    public let notificationCenter: NotificationCenter
    private var observers = [NSObjectProtocol]()
    
    public init(notificationCenter: NotificationCenter = .default) {
        self.notificationCenter = notificationCenter
    }
    
    public func addObserver(forName: Notification.Name, object: Any? = nil, queue: OperationQueue? = nil, using: @escaping (Notification) -> Void) {
        observers.append(notificationCenter.addObserver(forName: forName, object: object, queue: queue, using: using))
    }
    
    public func removeObservers() {
        for observer in observers {
            notificationCenter.removeObserver(observer)
        }
        observers.removeAll()
    }
}
