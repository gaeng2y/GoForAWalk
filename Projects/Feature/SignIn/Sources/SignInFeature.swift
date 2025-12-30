//
//  SignInFeature.swift
//  SignIn
//
//  Created by Kyeongmo Yang on 5/11/25.
//  Copyright © 2025 com.gaeng2y. All rights reserved.
//

import AuthServiceInterface
import ComposableArchitecture
import SignInInterface

public extension SignInFeature {
    static func live(authClient: any AuthClient) -> Self {
        Self { state, action in
            switch action {
            case .checkAuthorization:
                return .run { send in
                    if await authClient.loadToken() != nil {
                        await send(.isAlreadyAuthorized)
                    } else {
                        await authClient.deleteAll()
                    }
                }

            case .kakaoSignInButtonTapped:
                state.isLoading = true
                return .run { send in
                    do {
                        let (token, user) = try await authClient.signInWithKakao()
                        await send(.signInSuccess(token, user))
                    } catch {
                        await send(.signInFailure(error))
                    }
                }

            case .appleSignInButtonTapped:
                state.isLoading = true
                return .run { send in
                    do {
                        let (token, user) = try await authClient.signInWithApple()
                        await send(.signInSuccess(token, user))
                    } catch {
                        await send(.signInFailure(error))
                    }
                }

            case let .signInSuccess(token, _):
                state.isLoading = false
                return .run { send in
                    await authClient.saveToken(token)
                    await send(.isAlreadyAuthorized)
                }

            case let .signInFailure(error):
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
