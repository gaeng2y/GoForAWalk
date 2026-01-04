//
//  MainTabFeature.swift
//  MainFeature
//
//  Created by Kyeongmo Yang on 5/15/25.
//  Copyright © 2025 com.gaeng2y. All rights reserved.
//

import ComposableArchitecture
import FeedFeatureInterface
import FeedServiceInterface
import HistoryFeatureInterface
import MainFeatureInterface
import ProfileFeatureInterface
import RecordFeatureInterface
import SettingsFeatureInterface
import SwiftUI

public extension MainTabFeature {
    static func live(
        feedFeature: FeedFeature,
        historyFeature: FootstepHistoryFeature,
        profileFeature: ProfileFeature,
        settingsFeature: SettingsFeature,
        captureImageFeature: CaptureImageFeature,
        feedClient: any FeedClient
    ) -> Self {
        Self(
            feedFeature: feedFeature,
            historyFeature: historyFeature,
            profileFeature: profileFeature,
            settingsFeature: settingsFeature,
            captureImageFeature: captureImageFeature
        ) { state, action in
            switch action {
            case .selectTab(let tab):
                state.currentTab = tab
                return .none

            case .feed:
                return .none

            case .history:
                return .none

            case .profile:
                return .none

            case .settings(.delegate(.userDidLogout)):
                return .send(.delegate(.userDidLogout))

            case .settings:
                return .none

            case .floatingButtonTapped:
                return .run { send in
                    let availability = try await feedClient.checkTodayAvailability()
                    await send(.checkAvailabilityResponse(availability))
                }

            case .checkAvailabilityResponse(let availability):
                if availability.canCreateToday {
                    state.captureImage = CaptureImageFeature.State()
                } else {
                    state.showUnavailableAlert = true
                }
                return .none

            case .dismissUnavailableAlert:
                state.showUnavailableAlert = false
                return .none

            case .captureImage(.presented(.dismissButtonTapped)):
                state.captureImage = nil
                return .send(.feed(.onAppear))

            case .captureImage:
                return .none

            case .delegate:
                return .none
            }
        }
    }
}
