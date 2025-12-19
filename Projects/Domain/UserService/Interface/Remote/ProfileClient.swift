//
//  ProfileClient.swift
//  UserService
//
//  Created by Kyeongmo Yang on 6/24/25.
//  Copyright © 2025 com.gaeng2y. All rights reserved.
//

import Foundation

public protocol ProfileClient: Sendable {
    func fetchProfile() async throws -> Profile
    func withdrawUser() async throws
    func changeNickname(_ nickname: String) async throws
}
