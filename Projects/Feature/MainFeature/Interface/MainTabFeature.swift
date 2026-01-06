//
//  MainTabFeature.swift
//  MainFeatureInterface
//
//  Created by Kyeongmo Yang on 12/25/25.
//  Copyright © 2025 com.gaeng2y. All rights reserved.
//

import ComposableArchitecture
import FeedFeatureInterface
import FeedServiceInterface
import Foundation
import HistoryFeatureInterface
import ProfileFeatureInterface
import RecordFeatureInterface
import SettingsFeatureInterface
import SwiftUI

@Reducer
public struct MainTabFeature: @unchecked Sendable {
    // MARK: - State

    @ObservableState
    public struct State: Equatable {
        public var currentTab: MainTab = .home
        public var feed: FeedFeature.State = .init()
        public var history: FootstepHistoryFeature.State = .init()
        public var profile: ProfileFeature.State = .init()
        public var settings: SettingsFeature.State = .init()
        @Presents public var captureImage: CaptureImageFeature.State?
        public var showUnavailableAlert: Bool = false

        public init() {}
    }

    // MARK: - Action

    public enum Action {
        case selectTab(MainTab)
        case feed(FeedFeature.Action)
        case history(FootstepHistoryFeature.Action)
        case profile(ProfileFeature.Action)
        case settings(SettingsFeature.Action)
        case floatingButtonTapped
        case checkAvailabilityResponse(TodayFootstepAvailability)
        case dismissUnavailableAlert
        case captureImage(PresentationAction<CaptureImageFeature.Action>)
        case delegate(Delegate)

        public enum Delegate {
            case userDidLogout
        }
    }

    // MARK: - Dependencies

    let feedFeature: FeedFeature
    let historyFeature: FootstepHistoryFeature
    let profileFeature: ProfileFeature
    let settingsFeature: SettingsFeature
    let captureImageFeature: CaptureImageFeature
    let reduce: (inout State, Action) -> Effect<Action>

    public init(
        feedFeature: FeedFeature,
        historyFeature: FootstepHistoryFeature,
        profileFeature: ProfileFeature,
        settingsFeature: SettingsFeature,
        captureImageFeature: CaptureImageFeature,
        reduce: @escaping (inout State, Action) -> Effect<Action>
    ) {
        self.feedFeature = feedFeature
        self.historyFeature = historyFeature
        self.profileFeature = profileFeature
        self.settingsFeature = settingsFeature
        self.captureImageFeature = captureImageFeature
        self.reduce = reduce
    }

    public var body: some ReducerOf<Self> {
        Scope(state: \.feed, action: \.feed) {
            feedFeature
        }
        Scope(state: \.history, action: \.history) {
            historyFeature
        }
        Scope(state: \.profile, action: \.profile) {
            profileFeature
        }
        Scope(state: \.settings, action: \.settings) {
            settingsFeature
        }
        Reduce(reduce)
            .ifLet(\.$captureImage, action: \.captureImage) {
                captureImageFeature
            }
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
