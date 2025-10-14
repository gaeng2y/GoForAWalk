//
//  FootstepsResponseDTO.swift
//  FeedServiceInterface
//
//  Created by Kyeongmo Yang on 6/10/25.
//  Copyright © 2025 com.gaeng2y. All rights reserved.
//

import Foundation

public struct FootstepsResponseDTO: Decodable {
    private enum CodingKeys: String, CodingKey {
        case id = "footstepId"
        case userNickname
        case content
        case imageUrl
        case createdAt
    }
    
    let id: Int
    let userNickname: String
    let content: String?
    let imageUrl: String
    let createdAt: String
    
    public func toDomain() -> Footstep {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [
            .withInternetDateTime,
            .withTimeZone,
            .withFractionalSeconds
        ]
        return .init(
            id: id,
            userNickname: userNickname,
            createdAt: formatter.date(from: createdAt) ?? .now,
            imageUrl: URL(string: imageUrl),
            content: content
        )
    }
}
