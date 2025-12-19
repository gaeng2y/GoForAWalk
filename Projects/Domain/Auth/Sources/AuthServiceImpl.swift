//
//  AuthServiceImpl.swift
//  Auth
//
//  Created by Kyeongmo Yang on 12/20/25.
//  Copyright © 2025 com.gaeng2y. All rights reserved.
//

import AuthInterface
import Foundation
import NetworkingInterface

public struct AuthServiceImpl: AuthService {
    private let networkService: NetworkService
    
    public init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    public func signIn(type: LoginType, idToken: String) async throws -> (Token, User) {
        let dto = SignInRequestDTO(idToken: idToken)
        let endpoint = AuthEndpoint.signIn(type, dto)
        let response: SignInResponseDTO = try await networkService.request(endpoint)
        return response.toDomain()
    }
    
    public func saveToken(_ token: Token) {
        
    }
    
    public func loadToken() -> Token {
        // TODO: - KeyChainStore 처리 후 수정
        Token(accessToken: "", userId: "")
    }
    
    public func deleteAllTokens() async {
        
    }
}
