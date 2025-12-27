//
//  FeatureDependencyKeys.swift
//  DependencyInjection
//
//  Created by Kyeongmo Yang on 12/20/25.
//  Copyright © 2025 com.gaeng2y. All rights reserved.
//

import Dependencies
import FeedFeature
import FeedFeatureInterface
import Foundation
import MainFeature
import MainFeatureInterface
import SettingsFeature
import SettingsFeatureInterface

// MARK: - FeedFeature

private enum FeedFeatureKey: DependencyKey {
    static var liveValue: FeedFeature {
        @Dependency(\.feedClient) var feedClient

        return FeedFeature.live(feedClient: feedClient)
    }
}

// MARK: - MainTabFeature

private enum MainTabFeatureKey: DependencyKey {
    static var liveValue: MainTabFeature {
        MainTabFeature.live()
    }
}

// MARK: - SettingsFeature

private enum SettingsFeatureKey: DependencyKey {
    static var liveValue: SettingsFeature {
        @Dependency(\.authClient) var authClient
        @Dependency(\.profileClient) var profileClient

        return SettingsFeature.live(
            authClient: authClient,
            profileClient: profileClient
        )
    }
}

// MARK: - DependencyValues

extension DependencyValues {
    public var feedFeature: FeedFeature {
        get { self[FeedFeatureKey.self] }
        set { self[FeedFeatureKey.self] = newValue }
    }

    public var mainTabFeature: MainTabFeature {
        get { self[MainTabFeatureKey.self] }
        set { self[MainTabFeatureKey.self] = newValue }
    }

    public var settingsFeature: SettingsFeature {
        get { self[SettingsFeatureKey.self] }
        set { self[SettingsFeatureKey.self] = newValue }
    }
}
