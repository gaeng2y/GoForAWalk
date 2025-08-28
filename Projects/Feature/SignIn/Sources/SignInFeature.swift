//
//  SignInFeature.swift
//  SignIn
//
//  Created by Kyeongmo Yang on 5/11/25.
//  Copyright © 2025 com.gaeng2y. All rights reserved.
//

import Auth
import AuthInterface
import AuthenticationServices
import ComposableArchitecture
import GlobalThirdPartyLibrary
import KakaoSDKAuth
import KakaoSDKUser
import KeyChainStore

@Reducer
public struct SignInFeature {
    @ObservableState
    public struct State {
        public var isLoading: Bool = false
        @Presents var alert: AlertState<Action.Alert>?
        
        public init() {}
    }
    
    public enum Action {
        case alert(PresentationAction<Alert>)
        case checkAuthorization
        case isAlreadyAuthorized
        case kakaoSignInButtonTapped
        case signInWithKakakoResponse(AuthInterface.Token, AuthInterface.User)
        case signInWithKakaoError(Error)
        case signInWithAppleCredential(ASAuthorization)
        case signInWithAppleError(Error)
        
        @CasePathable
        public enum Alert {
            case messageReceived(String)
        }
    }
    
    @Dependency(\.authClient) var authClient
    
    public init() {}
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .checkAuthorization:
                if KeyChainStore.shared.validateToken() {
                    return .send(.isAlreadyAuthorized)
                } else {
                    return .run { send in
                        await authClient.deleteAllTokens()
                    }
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
                        let (token, userInfo) = try await authClient.signIn(.kakao, oauthToken?.idToken ?? "")
                        await send(.signInWithKakakoResponse(token, userInfo))
                    } catch {
                        await send(.signInWithKakaoError(error))
                    }
                }
                
            case let .signInWithKakakoResponse(token, _):
                state.isLoading = false
                authClient.saveToken(token)
                return .send(.isAlreadyAuthorized)
                
            case let .signInWithKakaoError(error):
                state.isLoading = false
                state.alert = AlertState(
                    title: {
                        TextState("알림")
                    }, actions: {
                        ButtonState {
                            TextState("확인")
                        }
                    }, message: {
                        TextState(error.localizedDescription)
                    })
                return .none
                
            case let .signInWithAppleCredential(authorization):
                state.isLoading = true
                
                return .run { send in
                    if let credential = authorization.credential as? ASAuthorizationAppleIDCredential,
                       let identityToken = credential.identityToken {
                        let (token, _) = try await authClient.signIn(.apple, String(data: identityToken, encoding: .utf8) ?? "")
                        authClient.saveToken(token)
                        await send(.isAlreadyAuthorized)
                    } else {
                        await send(.signInWithAppleError(NSError(domain: "AppleSignInError", code: 999)))
                    }
                }
                
            case let .signInWithAppleError(error):
                state.isLoading = false
                state.alert = AlertState(
                    title: {
                        TextState("알림")
                    }, actions: {
                        ButtonState {
                            TextState("확인")
                        }
                    }, message: {
                        TextState(error.localizedDescription)
                    })
                return .none
                
            case .isAlreadyAuthorized:
                state.isLoading = false
                return .none
                
            default:
                return .none
            }
        }
    }
}
