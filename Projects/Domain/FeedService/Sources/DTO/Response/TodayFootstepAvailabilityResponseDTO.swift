//
//  TodayFootstepAvailabilityResponseDTO.swift
//  FeedServiceInterface
//
//  Created by Kyeongmo Yang on 11/20/25.
//  Copyright © 2025 com.gaeng2y. All rights reserved.
//

import FeedServiceInterface
import Foundation

struct TodayFootstepAvailabilityResponseDTO: Decodable, Sendable {
    let canCreateToday: Bool
    let todayDate: String
    let existingFootstep: ExistingFootstep?
    
    struct ExistingFootstep: Decodable, Sendable {
        let footstepId: Int
        let imageUrl: String
        let content: String
        let createdAt: String
    }
}

extension TodayFootstepAvailabilityResponseDTO {
    func toDomain() -> TodayFootstepAvailability {
        TodayFootstepAvailability(
            canCreateToday: canCreateToday,
            todayDate: todayDate,
            existingFootstep: existingFootstep.map { existing in
                TodayFootstepAvailability.ExistingFootstepInfo(
                    footstepId: existing.footstepId,
                    imageUrl: existing.imageUrl,
                    content: existing.content,
                    createdAt: DateFormatter.footstep.date(from: existing.createdAt) ?? .now
                )
            }
        )
    }
}
