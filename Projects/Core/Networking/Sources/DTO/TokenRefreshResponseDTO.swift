//
//  TokenRefreshResponseDTO.swift
//  NetworkingInterface
//
//  Created by Kyeongmo Yang on 12/20/25.
//  Copyright © 2025 com.gaeng2y. All rights reserved.
//

import Foundation

struct TokenRefreshResponseDTO: Decodable, Sendable {
    let data: TokenRefreshDataDTO
}

struct TokenRefreshDataDTO: Decodable, Sendable {
    let credentials: TokenCredentialsDTO
}

struct TokenCredentialsDTO: Decodable, Sendable {
    let accessToken: String
    let refreshToken: String
}
