//
//  CalendarFootstepsResponseDTO.swift
//  FeedService
//
//  Created by Kyeongmo Yang on 1/1/26.
//  Copyright © 2026 com.gaeng2y. All rights reserved.
//

import FeedServiceInterface
import Foundation

struct CalendarFootstepsResponseDTO: Decodable, Sendable {
    let footsteps: [CalendarFootstepDTO]
}

struct CalendarFootstepDTO: Decodable, Sendable {
    let footstepId: Int
    let userNickname: String
    let date: String
    let imageUrl: String
    let content: String?
    let createdAt: String

    func toDomain() -> Footstep {
        Footstep(
            id: footstepId,
            userNickname: userNickname,
            date: date,
            createdAt: DateFormatter.footstep.date(from: createdAt) ?? .now,
            imageUrl: URL(string: imageUrl),
            content: content
        )
    }
}
