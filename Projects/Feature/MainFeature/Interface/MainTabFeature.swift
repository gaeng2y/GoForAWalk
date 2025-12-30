//
//  MainTabFeature.swift
//  MainFeatureInterface
//
//  Created by Kyeongmo Yang on 12/25/25.
//  Copyright © 2025 com.gaeng2y. All rights reserved.
//

import ComposableArchitecture
import FeedFeatureInterface
import Foundation
import ProfileFeatureInterface
import SettingsFeatureInterface
import SwiftUI

@Reducer
public struct MainTabFeature {
    // MARK: - State

    @ObservableState
    public struct State: Equatable {
        public var currentTab: MainTab = .home
        public var feed: FeedFeature.State = .init()
        public var profile: ProfileFeature.State = .init()
        public var settings: SettingsFeature.State = .init()

        public init() {}
    }

    // MARK: - Action

    public enum Action {
        case selectTab(MainTab)
        case feed(FeedFeature.Action)
        case profile(ProfileFeature.Action)
        case settings(SettingsFeature.Action)
        case delegate(Delegate)

        public enum Delegate {
            case userDidLogout
        }
    }

    // MARK: - Dependencies

    let feedFeature: FeedFeature
    let profileFeature: ProfileFeature
    let settingsFeature: SettingsFeature
    let reduce: (inout State, Action) -> Effect<Action>

    public init(
        feedFeature: FeedFeature,
        profileFeature: ProfileFeature,
        settingsFeature: SettingsFeature,
        reduce: @escaping (inout State, Action) -> Effect<Action>
    ) {
        self.feedFeature = feedFeature
        self.profileFeature = profileFeature
        self.settingsFeature = settingsFeature
        self.reduce = reduce
    }

    public var body: some ReducerOf<Self> {
        Scope(state: \.feed, action: \.feed) {
            feedFeature
        }
        Scope(state: \.profile, action: \.profile) {
            profileFeature
        }
        Scope(state: \.settings, action: \.settings) {
            settingsFeature
        }
        Reduce(reduce)
    }
}

// MARK: - Preview

//extension MainTabFeature {
//    public static func preview() -> Self {
//        Self(
//            feedFeature: .preview(),
//            profileFeature: .preview(),
//            settingsFeature: .preview()
//        ) { state, action in
//            switch action {
//            case .selectTab(let tab):
//                state.currentTab = tab
//                return .none
//
//            case .feed:
//                return .none
//
//            case .profile:
//                return .none
//
//            case .settings:
//                return .none
//
//            case .delegate:
//                return .none
//            }
//        }
//    }
//}
