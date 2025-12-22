//
//  FetchFootstepsResponseDTO.swift
//  FeedServiceInterface
//
//  Created by Kyeongmo Yang on 6/9/25.
//  Copyright © 2025 com.gaeng2y. All rights reserved.
//

/*
 "footstepId": 1,
 "userNickname": "abc",
 "content": "이 편지는 영국에서...", (nullable)
 "imageUrl": "htts://google/image1.png",
 "createdAt": "2025-05-10T22:00+09:00"
 */

import FeedServiceInterface
import Foundation

struct FetchFootstepsResponseDTO: Decodable, Sendable {
    let footsteps: [FootstepsResponseDTO]
}

struct FootstepsResponseDTO: Decodable {
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
    
    func toDomain() -> Footstep {
        Footstep(
            id: id,
            userNickname: userNickname,
            createdAt: DateFormatter.footstep.date(from: createdAt) ?? .now,
            imageUrl: URL(string: imageUrl),
            content: content
        )
    }
}
