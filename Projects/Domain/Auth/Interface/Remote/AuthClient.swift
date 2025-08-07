//
//  AuthClient.swift
//  AuthInterface
//
//  Created by Kyeongmo Yang on 4/22/25.
//  Copyright © 2025 com.gaeng2y. All rights reserved.
//

import Foundation

public struct AuthClient {
    public var signIn: @Sendable (LoginType, String) async throws -> (Token, User)
    public var saveToken: (Token) -> Void
    public var loadToken: @Sendable () -> Token
    
    public init(
        signIn: @escaping @Sendable (LoginType, String) async throws -> (Token, User),
        saveToken: @escaping (Token) -> Void,
        loadToken: @escaping @Sendable () -> Token
    ) {
        self.signIn = signIn
        self.saveToken = saveToken
        self.loadToken = loadToken
    }
}
