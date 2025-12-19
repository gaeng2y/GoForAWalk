//
//  AuthServiceImpl.swift
//  Auth
//
//  Created by Kyeongmo Yang on 12/20/25.
//  Copyright © 2025 com.gaeng2y. All rights reserved.
//

import AuthInterface
import Foundation
import KeyChainStoreInterface
import NetworkingInterface

public final class AuthServiceImpl: AuthService {
    private let networkService: NetworkService
    private let keychainStore: KeychainStore
    
    public init(
        networkService: NetworkService,
        keychainStore: KeychainStore
    ) {
        self.networkService = networkService
        self.keychainStore = keychainStore
    }
    
    public func signIn(type: LoginType, idToken: String) async throws -> (Token, User) {
        let dto = SignInRequestDTO(idToken: idToken)
        let endpoint = AuthEndpoint.signIn(type, dto)
        let response: SignInResponseDTO = try await networkService.request(endpoint)
        return response.toDomain()
    }
    
    public func saveToken(_ token: Token) {
        keychainStore.save(property: .accessToken, value: token.accessToken)
        keychainStore.save(property: .refreshToken, value: token.refreshToken)
    }
    
    public func loadToken() -> Token? {
        guard let accessToken = try? keychainStore.load(property: .accessToken),
              let refreshToken = try? keychainStore.load(property: .refreshToken) else {
            return nil
        }
        
        return Token(accessToken: accessToken, refreshToken: refreshToken)
    }
    
    public func deleteAll() {
        keychainStore.deleteAll()
    }
}
