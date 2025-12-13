//
//  AuthClient.swift
//  goforawalk
//
//  Created by Kyeongmo Yang on 4/28/25.
//

import AuthInterface
import ComposableArchitecture
import Foundation
import Networking

extension AuthClient: DependencyKey {
    public static let liveValue: AuthClient = {
        let localAuthStore = LocalAuthStoreImpl()

        return AuthClient(
            signIn: { domain, idToken in
                let requestDTO = SignInRequestDTO(idToken: idToken)
                let apiEndpoint = AuthEndpoint.signIn(provider: domain, requestDTO)
                let response: SignInResponseDTO = try await NetworkProviderImpl.shared.request(apiEndpoint)
                return response.toDomain()
            },
            refreshToken: {
                let currentToken = localAuthStore.loadToken()
                let apiEndpoint = AuthEndpoint.refreshToken(refreshToken: currentToken.refreshToken)
                let response: SignInResponseDTO = try await NetworkProviderImpl.shared.requestWithoutRetry(apiEndpoint)
                return response.toDomain()
            },
            saveToken: { token in
                localAuthStore.saveToken(token: token)
            },
            loadToken: {
                localAuthStore.loadToken()
            },
            deleteAllTokens: {
                await MainActor.run {
                    localAuthStore.deleteAllTokens()
                }
            }
        )
    }()
}

extension AuthClient: TestDependencyKey {
    public static var previewValue = Self(
        signIn: unimplemented("\(Self.self).signIn"),
        refreshToken: unimplemented("\(Self.self).refreshToken"),
        saveToken: unimplemented("\(Self.self).saveToken"),
        loadToken: unimplemented("\(Self.self).loadToken"),
        deleteAllTokens: unimplemented("\(Self.self).deleteAllTokens")
    )

    public static let testValue = Self(
        signIn: unimplemented("\(Self.self).signIn"),
        refreshToken: unimplemented("\(Self.self).refreshToken"),
        saveToken: unimplemented("\(Self.self).saveToken"),
        loadToken: unimplemented("\(Self.self).loadToken"),
        deleteAllTokens: unimplemented("\(Self.self).deleteAllTokens")
    )
}

extension DependencyValues {
    public var authClient: AuthClient {
        get { self[AuthClient.self] }
        set { self[AuthClient.self] = newValue }
    }
}
