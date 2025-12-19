//
//  UserInfo.swift
//  AuthInterface
//
//  Created by Kyeongmo Yang on 5/6/25.
//  Copyright © 2025 com.gaeng2y. All rights reserved.
//

import Foundation

public struct User: Sendable {
    public let nickname: String
    public let email: String
    
    public init(nickname: String, email: String) {
        self.nickname = nickname
        self.email = email
    }
}

public extension User {
    static let mock: User = .init(
        nickname: "양경모",
        email: "gaeng2y@gmail.com"
    )
}
