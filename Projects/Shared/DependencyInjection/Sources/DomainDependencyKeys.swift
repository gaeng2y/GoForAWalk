//
//  DomainDependencyKeys.swift
//  DependencyInjection
//
//  Created by Kyeongmo Yang on 12/20/25.
//  Copyright © 2025 com.gaeng2y. All rights reserved.
//

import Auth
import AuthInterface
import Dependencies
import FeedService
import FeedServiceInterface
import Foundation
import KeyChainStoreInterface
import NetworkingInterface

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

// MARK: - FeedClient

private enum FeedClientKey: DependencyKey {
    static var liveValue: any FeedClient {
        @Dependency(\.networkService) var networkService
        
        return FeedClientImpl(networkService: networkService)
    }
}

// MARK: - DependencyValues

extension DependencyValues {
    public var authService: any AuthClient {
        get { self[AuthClientKey.self] }
        set { self[AuthClientKey.self] = newValue }
    }
    
    public var feedClient: any FeedClient {
        get { self[FeedClientKey.self] }
        set { self[FeedClientKey.self] = newValue }
    }
}
