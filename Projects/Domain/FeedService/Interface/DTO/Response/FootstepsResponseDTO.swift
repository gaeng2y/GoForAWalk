//
//  FootstepsResponseDTO.swift
//  FeedServiceInterface
//
//  Created by Kyeongmo Yang on 6/10/25.
//  Copyright © 2025 com.gaeng2y. All rights reserved.
//

import Foundation

public struct FootstepsResponseDTO: Decodable {
    let id: Int
    let userNickname: String
    let content: String?
    let imageUrl: String
    let createdAt: String
    
    private enum CodingKeys: String, CodingKey {
        case id = "footstepId"
        case userNickname
        case content
        case imageUrl
        case createdAt
    }
    
    private static let iso8601DateFormatter: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [
            .withInternetDateTime,
            .withTimeZone,
            .withFractionalSeconds
        ]
        return formatter
    }()
    
    public func toDomain() -> Footstep {
        Footstep(
            id: id,
            userNickname: userNickname,
            createdAt: Self.iso8601DateFormatter.date(from: createdAt) ?? .now,
            imageUrl: URL(string: imageUrl),
            content: content
        )
    }
}
