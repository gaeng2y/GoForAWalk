//
//  CameraSetting.swift
//  Camera
//
//  Created by Kyeongmo Yang on 8/2/25.
//  Copyright © 2025 com.gaeng2y. All rights reserved.
//

import Foundation

public enum CameraSetting {
    public static let ratio: Double = 1 / 1
    public static let zoomFactorBackDevice = 2.0 // 후면 카메라 고정 배율 -> 기본이 0.5이므로 2배해주면 원래 배율 나옴
    public static let dropFrame = 6
}
