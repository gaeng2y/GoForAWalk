//
//  RootFeature.swift
//  Root
//
//  Created by Kyeongmo Yang on 5/5/25.
//  Copyright © 2025 com.gaeng2y. All rights reserved.
//

import ComposableArchitecture
import DependencyInjection
import Foundation
import MainFeatureInterface
import SignInInterface
import Util

@Reducer
public struct RootFeature: @unchecked Sendable {
    private static let hasLaunchedBeforeKey = "hasLaunchedBefore"

    @ObservableState
    public struct State: Equatable {
        var isSignIn: Bool = false
        var signIn: SignInFeature.State = .init()
        var mainTab: MainTabFeature.State = .init()

        public init() {}
    }

    public enum Action {
        case onAppear
        case signIn(SignInFeature.Action)
        case mainTab(MainTabFeature.Action)
        case logout
    }

    @Dependency(\.authClient) var authClient
    @Dependency(\.mainTabFeature) var mainTabFeature
    @Dependency(\.signInFeature) var signInFeature

    public init() {}

    public var body: some ReducerOf<Self> {
        Scope(state: \.signIn, action: \.signIn) {
            signInFeature
        }

        Scope(state: \.mainTab, action: \.mainTab) {
            mainTabFeature
        }

        Reduce { state, action in
            switch action {
            case .onAppear:
                return .merge(
                    // 첫 실행 감지 및 로그인 상태 확인
                    .run { send in
                        // iOS Keychain은 앱 삭제 후에도 유지되므로
                        // 앱 재설치 시 이전 토큰이 남아있을 수 있음
                        let hasLaunchedBefore = UserDefaults.standard.bool(forKey: Self.hasLaunchedBeforeKey)
                        if !hasLaunchedBefore {
                            await authClient.deleteAll()
                            UserDefaults.standard.set(true, forKey: Self.hasLaunchedBeforeKey)
                            #if DEBUG
                            debugPrint("🔐 [RootFeature] First launch detected - Keychain cleared")
                            #endif
                        }
                        // 로그인 상태 확인
                        await send(.signIn(.checkAuthorization))
                    },
                    // 강제 로그아웃 알림 구독 (Refresh Token 갱신 실패 시)
                    .run { send in
                        for await _ in NotificationCenter.default.notifications(named: .forceLogoutRequired) {
                            await send(.logout)
                        }
                    }
                )

            case .signIn(.isAlreadyAuthorized):
                state.isSignIn = true
                return .none

            case .mainTab(.delegate(.userDidLogout)):
                return .send(.logout)

            case .logout:
                state.isSignIn = false
                state.signIn = .init()
                state.mainTab = .init()
                return .none

            default:
                return .none
            }
        }
    }
}
