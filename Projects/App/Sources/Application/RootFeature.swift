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
import SplashFeatureInterface
import Util

@Reducer
public struct RootFeature: @unchecked Sendable {
    private static let hasLaunchedBeforeKey = "hasLaunchedBefore"

    @ObservableState
    public struct State: Equatable {
        public enum Destination: Equatable {
            case splash
            case signIn
            case mainTab
        }

        var destination: Destination = .splash
        var splash: SplashFeature.State = .init()
        var signIn: SignInFeature.State = .init()
        var mainTab: MainTabFeature.State = .init()

        public init() {}
    }

    public enum Action {
        case onAppear
        case splash(SplashFeature.Action)
        case signIn(SignInFeature.Action)
        case mainTab(MainTabFeature.Action)
        case logout
    }

    @Dependency(\.authClient) var authClient
    @Dependency(\.splashFeature) var splashFeature
    @Dependency(\.mainTabFeature) var mainTabFeature
    @Dependency(\.signInFeature) var signInFeature

    public init() {}

    public var body: some ReducerOf<Self> {
        Scope(state: \.splash, action: \.splash) {
            splashFeature
        }

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
                    // 첫 실행 감지 후 Splash 시작
                    .run { send in
                        let hasLaunchedBefore = UserDefaults.standard.bool(forKey: Self.hasLaunchedBeforeKey)
                        if !hasLaunchedBefore {
                            await authClient.deleteAll()
                            UserDefaults.standard.set(true, forKey: Self.hasLaunchedBeforeKey)
                            #if DEBUG
                            debugPrint("🔐 [RootFeature] First launch detected - Keychain cleared")
                            #endif
                        }
                        // 첫 실행 체크 완료 후 Splash 시작
                        await send(.splash(.onAppear))
                    },
                    // 강제 로그아웃 알림 구독 (Refresh Token 갱신 실패 시)
                    .run { send in
                        for await _ in NotificationCenter.default.notifications(named: .forceLogoutRequired) {
                            await send(.logout)
                        }
                    }
                )

            // MARK: - Splash Delegate

            case .splash(.delegate(.authenticated)):
                state.destination = .mainTab
                return .none

            case .splash(.delegate(.unauthenticated)):
                state.destination = .signIn
                return .none

            case .splash:
                return .none

            // MARK: - SignIn

            case .signIn(.isAlreadyAuthorized):
                state.destination = .mainTab
                return .none

            // MARK: - MainTab

            case .mainTab(.delegate(.userDidLogout)):
                return .send(.logout)

            case .logout:
                state.destination = .signIn
                state.signIn = .init()
                state.mainTab = .init()
                return .none

            default:
                return .none
            }
        }
    }
}
