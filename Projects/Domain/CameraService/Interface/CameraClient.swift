//
//  CameraClient.swift
//  CameraServiceInterface
//
//  Created by Kyeongmo Yang on 8/2/25.
//  Copyright © 2025 com.gaeng2y. All rights reserved.
//

import CoreImage
import Foundation
import SwiftUI

/// 카메라 기능을 제공하는 Domain 레이어 인터페이스
///
/// Core/Camera의 CameraService를 감싸서 Feature 레이어에 제공합니다.
public protocol CameraClient: Sendable {
    /// 카메라 프리뷰 스트림
    var previewStream: AsyncStream<CIImage> { get }

    /// 카메라 세션 시작
    func start() async

    /// 카메라 세션 중지
    func stop()

    /// 전면/후면 카메라 전환
    func switchCaptureDevice() async

    /// 사진 촬영
    func takePhoto() async -> Image
}
