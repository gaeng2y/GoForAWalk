//
//  TodayFootstepAvailabilityResponseDTO.swift
//  FeedServiceInterface
//
//  Created by Kyeongmo Yang on 11/20/25.
//  Copyright © 2025 com.gaeng2y. All rights reserved.
//

import Foundation

public struct TodayFootstepAvailabilityResponseDTO: Decodable {
    let canCreateToday: Bool
    let todayDate: String
    let existingFootstep: ExistingFootstep?

    public struct ExistingFootstep: Decodable {
        let footstepId: Int
        let imageUrl: String
        let content: String
        let createdAt: String
    }
}

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
    
    public init(canCreateToday: Bool, todayDate: String, existingFootstep: ExistingFootstepInfo?) {
        self.canCreateToday = canCreateToday
        self.todayDate = todayDate
        self.existingFootstep = existingFootstep
    }
}

extension TodayFootstepAvailabilityResponseDTO {
    private static let iso8601DateFormatter: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [
            .withInternetDateTime,
            .withTimeZone,
            .withFractionalSeconds
        ]
        return formatter
    }()

    public func toDomain() -> TodayFootstepAvailability {
        TodayFootstepAvailability(
            canCreateToday: canCreateToday,
            todayDate: todayDate,
            existingFootstep: existingFootstep.map { existing in
                TodayFootstepAvailability.ExistingFootstepInfo(
                    footstepId: existing.footstepId,
                    imageUrl: existing.imageUrl,
                    content: existing.content,
                    createdAt: Self.iso8601DateFormatter.date(from: existing.createdAt) ?? .now
                )
            }
        )
    }
}
