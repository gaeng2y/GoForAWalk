//
//  CameraClient+Impl.swift
//  CameraServiceInterface
//
//  Created by Kyeongmo Yang on 8/2/25.
//  Copyright © 2025 com.gaeng2y. All rights reserved.
//

import Camera
import CameraServiceInterface
import ComposableArchitecture
import Foundation

extension CameraClient: DependencyKey {
    public static let liveValue: CameraClient = {
        let camera = Camera()
        return CameraClient(
            start: {
                await camera.start()
            },
            stop: {
                camera.stop()
            },
            switchCaptureDevice: {
                await camera.switchCaptureDevice()
            },
            takePhoto: {
                await camera.takePhoto()
            },
            previewStream: {
                camera.previewStream
            }
        )
    }()
}

extension CameraClient: TestDependencyKey {
    public static var previewValue = Self(
        start: unimplemented("\(Self.self).start"),
        stop: unimplemented("\(Self.self).stop"),
        switchCaptureDevice: unimplemented("\(Self.self).switchCaptrueDevice"),
        takePhoto: unimplemented("\(Self.self).takePhoto"),
        previewStream: unimplemented("\(Self.self).previewStream")
    )
    
    public static let testValue = Self(
        start: unimplemented("\(Self.self).start"),
        stop: unimplemented("\(Self.self).stop"),
        switchCaptureDevice: unimplemented("\(Self.self).switchCaptrueDevice"),
        takePhoto: unimplemented("\(Self.self).takePhoto"),
        previewStream: unimplemented("\(Self.self).previewStream")
    )
}

extension DependencyValues {
    public var cameraClient: CameraClient {
        get { self[CameraClient.self] }
        set { self[CameraClient.self] = newValue }
    }
}
