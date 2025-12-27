//
//  CameraClientImpl.swift
//  CameraService
//
//  Created by Kyeongmo Yang on 8/2/25.
//  Copyright © 2025 com.gaeng2y. All rights reserved.
//

import CameraInterface
import CameraServiceInterface
import CoreImage
import Foundation
import SwiftUI

/// CameraClient 프로토콜의 구현체
///
/// Core/Camera의 CameraService를 사용하여 카메라 기능을 제공합니다.
public final class CameraClientImpl: CameraClient, @unchecked Sendable {
    private let cameraService: CameraService

    public init(cameraService: CameraService) {
        self.cameraService = cameraService
    }

    public var previewStream: AsyncStream<CIImage> {
        cameraService.previewStream
    }

    public func start() async {
        await cameraService.start()
    }

    public func stop() {
        cameraService.stop()
    }

    public func switchCaptureDevice() async {
        await cameraService.switchCaptureDevice()
    }

    public func takePhoto() async -> Image {
        await cameraService.takePhoto()
    }
}
