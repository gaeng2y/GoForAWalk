//
//  SignInFeature.swift
//  SignIn
//
//  Created by Kyeongmo Yang on 5/11/25.
//  Copyright © 2025 com.gaeng2y. All rights reserved.
//

import AuthServiceInterface
import AuthenticationServices
import ComposableArchitecture
import GlobalThirdPartyLibrary
import KakaoSDKAuth
import KakaoSDKUser
import KeyChainStore
import SignInInterface

public extension SignInFeature {
    static func live(authClient: any AuthClient) -> Self {
        Self { state, action in
            switch action {
            case .checkAuthorization:
                if authClient.loadToken() != nil {
                    return .send(.isAlreadyAuthorized)
                } else {
                    authClient.deleteAll()
                    return .none
                }
                
            case .kakaoSignInButtonTapped:
                state.isLoading = true
                
                return .run { @MainActor send in
                    do {
                        let oauthToken: OAuthToken? = try await withCheckedThrowingContinuation { continuation in
                            if UserApi.isKakaoTalkLoginAvailable() {
                                UserApi.shared.loginWithKakaoTalk { oauthToken, error in
                                    if let error {
                                        continuation.resume(throwing: error)
                                        return
                                    }
                                    continuation.resume(returning: oauthToken)
                                }
                            } else {
                                UserApi.shared.loginWithKakaoAccount { oauthToken, error in
                                    if let error {
                                        continuation.resume(throwing: error)
                                        return
                                    }
                                    continuation.resume(returning: oauthToken)
                                }
                            }
                        }
                        let (token, userInfo) = try await authClient.signIn(type: .kakao, idToken: oauthToken?.idToken ?? "")
                        await send(.signInWithKakakoResponse(token, userInfo))
                    } catch {
                        send(.signInWithKakaoError(error))
                    }
                }
                
            case let .signInWithKakakoResponse(token, _):
                state.isLoading = false
                authClient.saveToken(token)
                return .send(.isAlreadyAuthorized)
                
            case let .signInWithKakaoError(error):
                state.isLoading = false
                state.alert = AlertState(
                    title: { TextState("알림") },
                    actions: { ButtonState { TextState("확인") } },
                    message: { TextState(error.localizedDescription) }
                )
                return .none
                
            case let .signInWithAppleCredential(authorization):
                state.isLoading = true
                
                return .run(
                    operation: { send in
                        if let credential = authorization.credential as? ASAuthorizationAppleIDCredential,
                           let identityToken = credential.identityToken {
                            let (token, _) = try await authClient.signIn(type: .apple, idToken: String(data: identityToken, encoding: .utf8) ?? "")
                            authClient.saveToken(token)
                            await send(.isAlreadyAuthorized)
                        } else {
                            await send(.signInWithAppleError(NSError(domain: "AppleSignInError", code: 999)))
                        }
                    },
                    catch: { error, send in
                        await send(.signInWithAppleError(error))
                    }
                )
                
            case let .signInWithAppleError(error):
                state.isLoading = false
                state.alert = AlertState(
                    title: { TextState("알림") },
                    actions: { ButtonState { TextState("확인") } },
                    message: { TextState(error.localizedDescription) }
                )
                return .none
                
            case .isAlreadyAuthorized:
                state.isLoading = false
                return .none
                
            case .alert:
                return .none
            }
        }
    }
}
