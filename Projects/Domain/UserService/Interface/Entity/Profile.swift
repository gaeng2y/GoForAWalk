//
//  Profile.swift
//  UserService
//
//  Created by Kyeongmo Yang on 6/24/25.
//  Copyright © 2025 com.gaeng2y. All rights reserved.
//

import Foundation

public struct Profile: Equatable {
    let id: Int
    public let nickname: String
    let email: String?
    public let totalFootstepCount: Int
    public let footstepStreakDays: Int
    
    public init(
        id: Int = 0,
        nickname: String = "",
        email: String? = nil,
        totalFootstepCount: Int = 0,
        footstepStreakDays: Int = 0
    ) {
        self.id = id
        self.nickname = nickname
        self.email = email
        self.totalFootstepCount = totalFootstepCount
        self.footstepStreakDays = footstepStreakDays
    }
    
    static public func == (lhs: Profile, rhs: Profile) -> Bool {
        lhs.id == rhs.id
    }
}
