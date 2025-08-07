//
//  ProfileResponseDTO.swift
//  UserService
//
//  Created by Kyeongmo Yang on 6/24/25.
//  Copyright © 2025 com.gaeng2y. All rights reserved.
//

import Foundation

public struct ProfileResponseDTO: Decodable {
    let userId: Int
    let userNickname: String
    let userEmail: String?
    let userProvider: String
    let totalFootstepCount: Int
    let footstepStreakDays: Int
    
    public func toDomain() -> Profile {
        .init(
            id: userId,
            nickname: userNickname,
            email: userEmail,
            totalFootstepCount: totalFootstepCount,
            footstepStreakDays: footstepStreakDays
        )
    }
}
