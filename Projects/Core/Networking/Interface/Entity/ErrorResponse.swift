//
//  ErrorResponse.swift
//  NetworkingInterface
//
//  Created by Kyeongmo Yang on 12/31/25.
//  Copyright © 2025 com.gaeng2y. All rights reserved.
//

import Foundation

/// 서버 에러 응답 구조
///
/// 서버에서 에러 발생 시 반환되는 JSON 구조를 파싱하기 위한 DTO
public struct ErrorResponse: Decodable, Sendable {
    public let code: String
    public let message: String?
    public let detailMessage: String?
}
