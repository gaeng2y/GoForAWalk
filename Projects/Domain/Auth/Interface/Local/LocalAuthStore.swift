//
//  LocalAuthStore.swift
//  AuthInterface
//
//  Created by Kyeongmo Yang on 4/22/25.
//  Copyright © 2025 com.gaeng2y. All rights reserved.
//

import Foundation

public protocol LocalAuthStore {
    func loadToken() -> Token
    func saveToken(token: Token)
    func deleteAllTokens()
}
