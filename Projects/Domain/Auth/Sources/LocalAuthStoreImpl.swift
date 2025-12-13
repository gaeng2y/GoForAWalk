//
//  LocalAuthStoreImpl.swift
//  Auth
//
//  Created by Kyeongmo Yang on 5/9/25.
//  Copyright © 2025 com.gaeng2y. All rights reserved.
//

import Foundation
import AuthInterface
import KeyChainStore

public final class LocalAuthStoreImpl: LocalAuthStore {
    public init() {}
    
    public func loadToken() -> Token {
        Token(
            accessToken: KeyChainStore.shared.load(property: .accessToken),
            refreshToken: KeyChainStore.shared.load(property: .refreshToken),
            userId: KeyChainStore.shared.load(property: .userIdentifier)
        )
    }

    public func saveToken(token: Token) {
        KeyChainStore.shared.save(property: .accessToken, value: token.accessToken)
        KeyChainStore.shared.save(property: .refreshToken, value: token.refreshToken)
        KeyChainStore.shared.save(property: .userIdentifier, value: token.userId)
    }
    
    public func deleteAllTokens() {
        KeyChainStore.shared.deleteAll()
    }
}
