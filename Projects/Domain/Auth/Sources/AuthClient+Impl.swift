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
    public static let liveValue = AuthClient(
        signIn: { domain, idToken in
            let requestDTO = SignInRequestDTO(idToken: idToken)
            let apiEndpoint = AuthEndpoint.signIn(provider: domain, requestDTO)
            let response = try await NetworkProviderImpl.shared.request(apiEndpoint)
            return response.toDomain()
        },
        saveToken: { token in
            LocalAuthStoreImpl().saveToken(token: token)
        },
        loadToken: {
            LocalAuthStoreImpl().loadToken()
        },
        deleteAllTokens: {
            LocalAuthStoreImpl().deleteAllTokens()
        }
    )
}

extension AuthClient: TestDependencyKey {
    public static var previewValue = Self(
        signIn: unimplemented("\(Self.self).signIn"),
        saveToken: unimplemented("\(Self.self).saveToken"),
        loadToken: unimplemented("\(Self.self).loadToken"),
        deleteAllTokens: unimplemented("\(Self.self).deleteAllTokens")
    )
    
    public static let testValue = Self(
        signIn: unimplemented("\(Self.self).signIn"),
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
