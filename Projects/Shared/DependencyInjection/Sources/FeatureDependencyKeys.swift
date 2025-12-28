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
import RecordFeature
import RecordFeatureInterface
import SettingsFeature
import SettingsFeatureInterface
import SignIn
import SignInInterface

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

// MARK: - PostFootstepFeature

private enum PostFootstepFeatureKey: DependencyKey {
    static var liveValue: PostFootstepFeature {
        @Dependency(\.feedClient) var feedClient

        return PostFootstepFeature.live(feedClient: feedClient)
    }
}

// MARK: - CaptureImageFeature

private enum CaptureImageFeatureKey: DependencyKey {
    static var liveValue: CaptureImageFeature {
        @Dependency(\.cameraClient) var cameraClient
        @Dependency(\.postFootstepFeature) var postFootstepFeature

        return CaptureImageFeature.live(
            cameraClient: cameraClient,
            postFootstepFeature: postFootstepFeature
        )
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

// MARK: - SignInFeature

private enum SignInFeatureKey: DependencyKey {
    static var liveValue: SignInFeature {
        @Dependency(\.authClient) var authClient

        return SignInFeature.live(authClient: authClient)
    }
}

// MARK: - DependencyValues

extension DependencyValues {
    public var captureImageFeature: CaptureImageFeature {
        get { self[CaptureImageFeatureKey.self] }
        set { self[CaptureImageFeatureKey.self] = newValue }
    }

    public var feedFeature: FeedFeature {
        get { self[FeedFeatureKey.self] }
        set { self[FeedFeatureKey.self] = newValue }
    }

    public var mainTabFeature: MainTabFeature {
        get { self[MainTabFeatureKey.self] }
        set { self[MainTabFeatureKey.self] = newValue }
    }

    public var postFootstepFeature: PostFootstepFeature {
        get { self[PostFootstepFeatureKey.self] }
        set { self[PostFootstepFeatureKey.self] = newValue }
    }

    public var settingsFeature: SettingsFeature {
        get { self[SettingsFeatureKey.self] }
        set { self[SettingsFeatureKey.self] = newValue }
    }

    public var signInFeature: SignInFeature {
        get { self[SignInFeatureKey.self] }
        set { self[SignInFeatureKey.self] = newValue }
    }
}
