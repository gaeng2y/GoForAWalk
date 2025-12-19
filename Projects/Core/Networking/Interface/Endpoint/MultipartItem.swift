//
//  MultipartItem.swift
//  NetworkingInterface
//
//  Created by Kyeongmo Yang on 12/17/25.
//  Copyright © 2025 com.gaeng2y. All rights reserved.
//

import Foundation

/// Multipart 폼 데이터의 개별 항목
public struct MultipartFormItem: Sendable {
    public let data: Data
    public let name: String           // 폼 필드명 (서버에서 받는 key)
    public let fileName: String?      // 파일명 (nil이면 텍스트 필드)
    public let mimeType: String?      // MIME 타입
    
    // MARK: - Factory Methods
    
    /// 이미지 업로드용
    public static func image(
        _ data: Data,
        name: String,
        fileName: String = "image.jpg"
    ) -> MultipartFormItem {
        MultipartFormItem(data: data, name: name, fileName: fileName, mimeType: "image/jpeg")
    }
    
    /// PNG 이미지
    public static func png(
        _ data: Data,
        name: String,
        fileName: String = "image.png"
    ) -> MultipartFormItem {
        MultipartFormItem(data: data, name: name, fileName: fileName, mimeType: "image/png")
    }
    
    /// 텍스트 필드
    public static func field(name: String, value: String) -> MultipartFormItem {
        MultipartFormItem(
            data: value.data(using: .utf8) ?? Data(),
            name: name,
            fileName: nil,
            mimeType: nil
        )
    }
}
