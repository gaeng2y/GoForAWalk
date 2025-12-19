//
//  DependencyKeys.swift
//  DependencyInjection
//
//  Created by Claude Code
//

import Auth
import AuthInterface
import Dependencies
import Foundation
import KeyChainStore
import KeyChainStoreInterface
import Networking
import NetworkingInterface
import SwiftUI

// MARK: - Core

private enum NetworkServiceKey: DependencyKey {
    static let liveValue: NetworkService = NetworkServiceImpl()
}

private enum KeychainStoreKey: DependencyKey {
    static let liveValue: KeychainStore = KeychainStoreImpl()
}

extension DependencyValues {
    public var networkService: NetworkService {
        get { self[NetworkServiceKey.self] }
        set { self[NetworkServiceKey.self] = newValue }
    }
    
    public var keychainStore: KeychainStore {
        get { self[KeychainStoreKey.self] }
        set { self[KeychainStoreKey.self] = newValue }
    }
}

// MARK: - Domain

private enum AuthServiceKey: DependencyKey {
    static var liveValue: any AuthService {
        // 이미 등록된 networkService를 가져와서 주입
        @Dependency(\.networkService) var networkService
        @Dependency(\.keychainStore) var keychainStore
        
        return AuthServiceImpl(
            networkService: networkService,
            keychainStore: keychainStore
        )
    }
}

extension DependencyValues {
    public var authService: any AuthService {
        get { self[AuthServiceKey.self] }
        set { self[AuthServiceKey.self] = newValue }
    }
}

// MARK: - Feature
