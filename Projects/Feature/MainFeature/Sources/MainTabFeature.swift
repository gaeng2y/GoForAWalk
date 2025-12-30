//
//  MainTabFeature.swift
//  MainFeature
//
//  Created by Kyeongmo Yang on 5/15/25.
//  Copyright © 2025 com.gaeng2y. All rights reserved.
//

import ComposableArchitecture
import FeedFeatureInterface
import MainFeatureInterface
import ProfileFeatureInterface
import SettingsFeatureInterface
import SwiftUI

public extension MainTabFeature {
    static func live(
        feedFeature: FeedFeature,
        profileFeature: ProfileFeature,
        settingsFeature: SettingsFeature
    ) -> Self {
        Self(
            feedFeature: feedFeature,
            profileFeature: profileFeature,
            settingsFeature: settingsFeature
        ) { state, action in
            switch action {
            case .selectTab(let tab):
                state.currentTab = tab
                return .none
                
            case .feed:
                return .none
                
            case .profile:
                return .none
                
            case .settings(.delegate(.userDidLogout)):
                return .send(.delegate(.userDidLogout))
                
            case .settings:
                return .none
                
            case .delegate:
                return .none
            }
        }
    }
}
