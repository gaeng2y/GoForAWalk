//
//  DependencyKeys.swift
//  DependencyInjection
//
//  Created by Claude Code
//

import AVFoundation
import Camera
import CameraInterface
import CoreImage
import Dependencies
import Foundation
import KeyChainStore
import KeyChainStoreInterface
import Networking
import NetworkingInterface
import SwiftUI

// MARK: - NetworkProvider

private enum NetworkProviderKey: DependencyKey {
    public static let liveValue: NetworkProvider = NetworkProviderImpl()
}

extension DependencyValues {
    public var networkProvider: NetworkProvider {
        get { self[NetworkProviderKey.self] }
        set { self[NetworkProviderKey.self] = newValue }
    }
}
