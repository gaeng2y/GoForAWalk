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
    let id: Int
    let userNickname: String
    let date: String
    let imageUrl: String
    let content: String?
    let createdAt: String
    
    private enum CodingKeys: String, CodingKey {
        case id = "footstepId"
        case userNickname, date, imageUrl, content, createdAt
    }
    
    func toDomain() -> Footstep? {
        guard let createdAtDate = DateFormatter.footstep.date(from: createdAt) else {
            // 디버깅을 위해 에러를 로깅하는 것을 고려해보세요.
            return nil
        }
        
        return Footstep(
            id: id,
            userNickname: userNickname,
            date: date,
            createdAt: createdAtDate,
            imageUrl: URL(string: imageUrl),
            content: content
        )
    }
}
