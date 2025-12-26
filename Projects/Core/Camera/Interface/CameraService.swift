//
//  CameraService.swift
//  CameraInterface
//
//  Created by Kyeongmo Yang on 12/26/25.
//  Copyright © 2025 com.gaeng2y. All rights reserved.
//

import CoreImage
import SwiftUI

public protocol CameraService: Sendable {
    var previewStream: AsyncStream<CIImage> { get }
    
    func start() async
    func stop()
    func switchCaptureDevice() async
    func takePhoto() async -> Image
}
