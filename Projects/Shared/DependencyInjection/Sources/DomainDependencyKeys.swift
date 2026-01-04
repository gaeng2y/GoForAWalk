//
//  DomainDependencyKeys.swift
//  DependencyInjection
//
//  Created by Kyeongmo Yang on 12/20/25.
//  Copyright © 2025 com.gaeng2y. All rights reserved.
//

import AuthService
import AuthServiceInterface
import CameraInterface
import CameraService
import CameraServiceInterface
import Dependencies
import FeedService
import FeedServiceInterface
import Foundation
import KeyChainStoreInterface
import NetworkingInterface
import UserService
import UserServiceInterface

// MARK: - AuthClient

private enum AuthClientKey: DependencyKey {
    static var liveValue: any AuthClient {
        @Dependency(\.networkService) var networkService
        @Dependency(\.keychainStore) var keychainStore

        return AuthClientImpl(
            networkService: networkService,
            keychainStore: keychainStore
        )
    }
}

// MARK: - CameraClient

private enum CameraClientKey: DependencyKey {
    static var liveValue: any CameraClient {
        @Dependency(\.camera) var cameraService

        return CameraClientImpl(cameraService: cameraService)
    }
}

// MARK: - FeedClient

private enum FeedClientKey: DependencyKey {
    static var liveValue: any FeedClient {
        @Dependency(\.networkService) var networkService
        
        return FeedClientImpl(networkService: networkService)
    }
}

// MARK: - ProfileClient

private enum ProfileClientKey: DependencyKey {
    static var liveValue: any ProfileClient {
        @Dependency(\.networkService) var networkService
        
        return ProfileClientImpl(networkService: networkService)
    }
}

// MARK: - DependencyValues

public extension DependencyValues {
    var authClient: any AuthClient {
        get { self[AuthClientKey.self] }
        set { self[AuthClientKey.self] = newValue }
    }

    var cameraClient: any CameraClient {
        get { self[CameraClientKey.self] }
        set { self[CameraClientKey.self] = newValue }
    }

    var feedClient: any FeedClient {
        get { self[FeedClientKey.self] }
        set { self[FeedClientKey.self] = newValue }
    }

    var profileClient: any ProfileClient {
        get { self[ProfileClientKey.self] }
        set { self[ProfileClientKey.self] = newValue }
    }
}
