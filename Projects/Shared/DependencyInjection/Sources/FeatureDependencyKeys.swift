//
//  FeatureDependencyKeys.swift
//  DependencyInjection
//
//  Created by Kyeongmo Yang on 12/20/25.
//  Copyright © 2025 com.gaeng2y. All rights reserved.
//

import Dependencies
import Foundation
import SettingsFeature
import SettingsFeatureInterface

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
    public var settingsFeature: SettingsFeature {
        get { self[SettingsFeatureKey.self] }
        set { self[SettingsFeatureKey.self] = newValue }
    }
}
