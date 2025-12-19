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
import Networking
import NetworkingInterface
import SwiftUI

// MARK: - Core

private enum NetworkServiceKey: DependencyKey {
    typealias Value = any NetworkService
    static let liveValue: Value = NetworkServiceImpl()
}

extension DependencyValues {
    public var networkService: NetworkService {
        get { self[NetworkServiceKey.self] }
        set { self[NetworkServiceKey.self] = newValue }
    }
}

// MARK: - Domain

private enum AuthServiceKey: DependencyKey {
    static var liveValue: any AuthService {
        // 이미 등록된 networkService를 가져와서 주입
        @Dependency(\.networkService) var networkService
        
        return AuthServiceImpl(
            networkService: networkService
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
