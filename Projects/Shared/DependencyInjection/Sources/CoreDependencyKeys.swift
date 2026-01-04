//
//  CoreDependencyKeys.swift
//  DependencyInjection
//
//  Created by Kyeongmo Yang on 12/20/25.
//  Copyright © 2025 com.gaeng2y. All rights reserved.
//

import Camera
import CameraInterface
import Dependencies
import Foundation
import KeyChainStore
import KeyChainStoreInterface
import Networking
import NetworkingInterface

// MARK: - Camera
private enum CameraKey: DependencyKey {
    static var liveValue: CameraService {
        return CameraServiceImpl()
    }
}

// MARK: - KeychainStore

private enum KeychainStoreKey: DependencyKey {
    static let liveValue: KeychainStore = KeychainStoreImpl.shared
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
    var camera: CameraService {
        get { self[CameraKey.self] }
        set { self[CameraKey.self] = newValue }
    }
    
    var keychainStore: KeychainStore {
        get { self[KeychainStoreKey.self] }
        set { self[KeychainStoreKey.self] = newValue }
    }
    
    var networkService: NetworkService {
        get { self[NetworkServiceKey.self] }
        set { self[NetworkServiceKey.self] = newValue }
    }
}
