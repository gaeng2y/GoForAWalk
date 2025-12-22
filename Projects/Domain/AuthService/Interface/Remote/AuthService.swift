//
//  AuthService.swift
//  AuthServiceInterface
//
//  Created by Kyeongmo Yang on 4/22/25.
//  Copyright © 2025 com.gaeng2y. All rights reserved.
//

import Foundation

public protocol AuthClient: Sendable {
    func signIn(type: LoginType, idToken: String) async throws -> (Token, User)
    func saveToken(_ token: Token)
    func loadToken() -> Token?
    func deleteAll()
}
