//
//  AuthClientImpl.swift
//  Auth
//
//  Created by Kyeongmo Yang on 12/20/25.
//  Copyright © 2025 com.gaeng2y. All rights reserved.
//

import AuthenticationServices
import AuthServiceInterface
import Foundation
import KakaoSDKAuth
import KakaoSDKUser
import KeyChainStoreInterface
import NetworkingInterface
import UIKit

public final class AuthClientImpl: AuthClient, @unchecked Sendable {
    private let networkService: NetworkService
    private let keychainStore: KeychainStore

    public init(
        networkService: NetworkService,
        keychainStore: KeychainStore
    ) {
        self.networkService = networkService
        self.keychainStore = keychainStore
    }

    public func signInWithKakao() async throws -> (AuthServiceInterface.Token, AuthServiceInterface.User) {
        let oauthToken: OAuthToken = try await withCheckedThrowingContinuation { continuation in
            DispatchQueue.main.async {
                if UserApi.isKakaoTalkLoginAvailable() {
                    UserApi.shared.loginWithKakaoTalk { oauthToken, error in
                        if let error {
                            continuation.resume(throwing: error)
                            return
                        }
                        if let oauthToken {
                            continuation.resume(returning: oauthToken)
                        }
                    }
                } else {
                    UserApi.shared.loginWithKakaoAccount { oauthToken, error in
                        if let error {
                            continuation.resume(throwing: error)
                            return
                        }
                        if let oauthToken {
                            continuation.resume(returning: oauthToken)
                        }
                    }
                }
            }
        }

        return try await signIn(type: .kakao, idToken: oauthToken.idToken ?? "")
    }

    @MainActor
    public func signInWithApple() async throws -> (AuthServiceInterface.Token, AuthServiceInterface.User) {
        let credential = try await performAppleSignIn()

        guard let identityToken = credential.identityToken,
              let idTokenString = String(data: identityToken, encoding: .utf8) else {
            throw NSError(domain: "AuthClientImpl", code: -1, userInfo: [NSLocalizedDescriptionKey: "Apple ID Token을 가져올 수 없습니다."])
        }

        return try await signIn(type: .apple, idToken: idTokenString)
    }

    public func saveToken(_ token: AuthServiceInterface.Token) async {
        await keychainStore.save(property: .accessToken, value: token.accessToken)
        await keychainStore.save(property: .refreshToken, value: token.refreshToken)
    }

    public func loadToken() async -> AuthServiceInterface.Token? {
        guard let accessToken = try? await keychainStore.load(property: .accessToken),
              let refreshToken = try? await keychainStore.load(property: .refreshToken) else {
            return nil
        }

        return Token(accessToken: accessToken, refreshToken: refreshToken)
    }

    public func deleteAll() async {
        await keychainStore.deleteAll()
    }

    // MARK: - Private

    private func signIn(type: AuthServiceInterface.LoginType, idToken: String) async throws -> (AuthServiceInterface.Token, AuthServiceInterface.User) {
        let dto = SignInRequestDTO(idToken: idToken)
        let endpoint = AuthEndpoint.signIn(type, dto)
        let response: SignInResponseDTO = try await networkService.request(endpoint)
        return response.toDomain()
    }

    @MainActor
    private func performAppleSignIn() async throws -> ASAuthorizationAppleIDCredential {
        try await withCheckedThrowingContinuation { continuation in
            let provider = ASAuthorizationAppleIDProvider()
            let request = provider.createRequest()
            request.requestedScopes = [.email]

            let controller = ASAuthorizationController(authorizationRequests: [request])
            let delegate = AppleSignInDelegate(continuation: continuation)
            controller.delegate = delegate
            controller.presentationContextProvider = delegate

            // Retain delegate until completion
            objc_setAssociatedObject(controller, "delegate", delegate, .OBJC_ASSOCIATION_RETAIN)

            controller.performRequests()
        }
    }
}

// MARK: - AppleSignInDelegate

private final class AppleSignInDelegate: NSObject, ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    private let continuation: CheckedContinuation<ASAuthorizationAppleIDCredential, Error>

    init(continuation: CheckedContinuation<ASAuthorizationAppleIDCredential, Error>) {
        self.continuation = continuation
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let credential = authorization.credential as? ASAuthorizationAppleIDCredential {
            continuation.resume(returning: credential)
        } else {
            continuation.resume(throwing: NSError(domain: "AppleSignIn", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid credential type"]))
        }
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        continuation.resume(throwing: error)
    }

    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = scene.windows.first else {
            return UIWindow()
        }
        return window
    }
}
