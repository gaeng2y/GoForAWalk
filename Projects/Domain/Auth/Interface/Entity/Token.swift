//
//  Token.swift
//  AuthInterface
//
//  Created by Kyeongmo Yang on 4/22/25.
//  Copyright © 2025 com.gaeng2y. All rights reserved.
//

import Foundation

public struct Token: Equatable, Sendable {
    public let accessToken: String
    public let refreshToken: String
    
    public init(
        accessToken: String,
        refreshToken: String
    ) {
        self.accessToken = accessToken
        self.refreshToken = refreshToken
    }
}

public extension Token {
    static let mock = Token(
        accessToken: "mockAccessToken",
        refreshToken: "mockRefreshToken"
    )
}
