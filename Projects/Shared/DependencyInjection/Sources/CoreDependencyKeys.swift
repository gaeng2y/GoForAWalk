//
//  CoreDependencyKeys.swift
//  DependencyInjection
//
//  Created by Kyeongmo Yang on 12/20/25.
//  Copyright © 2025 com.gaeng2y. All rights reserved.
//

import Dependencies
import Foundation
import KeyChainStore
import KeyChainStoreInterface
import Networking
import NetworkingInterface

// MARK: - KeychainStore

private enum KeychainStoreKey: DependencyKey {
    static let liveValue: KeychainStore = KeychainStoreImpl()
}

// MARK: - NetworkService

private enum NetworkServiceKey: DependencyKey {
    static var liveValue: NetworkService {
        @Dependency(\.keychainStore) var keychainStore: KeychainStore
        return NetworkServiceImpl(keychainStore: keychainStore)
    }
}

// MARK: - DependencyValues

extension DependencyValues {
    public var keychainStore: KeychainStore {
        get { self[KeychainStoreKey.self] }
        set { self[KeychainStoreKey.self] = newValue }
    }
    
    public var networkService: NetworkService {
        get { self[NetworkServiceKey.self] }
        set { self[NetworkServiceKey.self] = newValue }
    }
}
