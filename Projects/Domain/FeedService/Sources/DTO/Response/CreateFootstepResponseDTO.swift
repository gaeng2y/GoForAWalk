//
//  CreateFootstepResponseDTO.swift
//  FeedServiceInterface
//
//  Created by Kyeongmo Yang on 8/13/25.
//  Copyright © 2025 com.gaeng2y. All rights reserved.
//

import Foundation

public struct CreateFootstepResponseDTO: Decodable, Sendable {
    let userId: Int
    let userNickname: String
    let footstepId: Int
    let date: String
    let imageURL: String
    let content: String?
    let createdAt: String
    
    private enum CodingKeys: String, CodingKey {
        case userId, userNickname, footstepId, date, content, createdAt
        case imageURL = "imageUrl"
    }
}
