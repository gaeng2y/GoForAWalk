//
//  TodayFootstepAvailability.swift
//  FeedService
//
//  Created by Kyeongmo Yang on 12/20/25.
//  Copyright © 2025 com.gaeng2y. All rights reserved.
//

import Foundation

public struct TodayFootstepAvailability {
    public let canCreateToday: Bool
    public let todayDate: String
    public let existingFootstep: ExistingFootstepInfo?
    
    public struct ExistingFootstepInfo {
        public let footstepId: Int
        public let imageUrl: String
        public let content: String
        public let createdAt: Date
    }
    
    public init(
        canCreateToday: Bool,
        todayDate: String,
        existingFootstep: ExistingFootstepInfo?
    ) {
        self.canCreateToday = canCreateToday
        self.todayDate = todayDate
        self.existingFootstep = existingFootstep
    }
}
