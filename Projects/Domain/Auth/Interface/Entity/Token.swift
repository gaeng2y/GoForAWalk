//
//  Token.swift
//  AuthInterface
//
//  Created by Kyeongmo Yang on 4/22/25.
//  Copyright © 2025 com.gaeng2y. All rights reserved.
//

import Foundation

public struct Token: Equatable {
    public let accessToken: String
    public let userId: String
    
    public init(
        accessToken: String,
        userId: String
    ) {
        self.accessToken = accessToken
        self.userId = userId
    }
}

public extension Token {
    static let mock = Token(
        accessToken: "mockAccessToken",
        userId: "123"
    )
}
