//
//  SessionExpiredNotifier.swift
//  NetworkingInterface
//
//  Created by Kyeongmo Yang on 12/9/25.
//  Copyright © 2025 com.gaeng2y. All rights reserved.
//

import Foundation

public enum SessionExpiredNotifier {
    public static let sessionExpiredNotification = Notification.Name("SessionExpiredNotification")

    public static func notifySessionExpired() {
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: sessionExpiredNotification, object: nil)
        }
    }
}
