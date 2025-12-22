//
//  FootstepDateFormatter.swift
//  FeedService
//
//  Created by Kyeongmo Yang on 12/20/25.
//  Copyright © 2025 com.gaeng2y. All rights reserved.
//

import Foundation

extension DateFormatter {
    static let footstep: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [
            .withInternetDateTime,
            .withTimeZone,
            .withFractionalSeconds
        ]
        return formatter
    }()
}
