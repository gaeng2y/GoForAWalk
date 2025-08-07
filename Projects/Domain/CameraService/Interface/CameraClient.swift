//
//  CameraClient.swift
//  CameraServiceInterface
//
//  Created by Kyeongmo Yang on 8/2/25.
//  Copyright © 2025 com.gaeng2y. All rights reserved.
//

import Foundation
import SwiftUI

public struct CameraClient {
    public var start: @Sendable () async -> Void
    public var stop: @Sendable () -> Void
    public var switchCaptureDevice: @Sendable () async -> Void
    public var takePhoto: @Sendable () async -> Image
    public var previewStream: @Sendable () -> AsyncStream<CIImage>
    
    public init(
        start: @escaping @Sendable () async -> Void,
        stop: @escaping @Sendable () -> Void,
        switchCaptureDevice: @escaping @Sendable () async -> Void,
        takePhoto: @escaping @Sendable () async -> Image,
        previewStream: @escaping @Sendable () -> AsyncStream<CIImage>
    ) {
        self.start = start
        self.stop = stop
        self.switchCaptureDevice = switchCaptureDevice
        self.takePhoto = takePhoto
        self.previewStream = previewStream
    }
}
