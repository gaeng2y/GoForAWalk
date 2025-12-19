//
//  HTTPTask.swift
//  NetworkingInterface
//
//  Created by Kyeongmo Yang on 12/17/25.
//  Copyright © 2025 com.gaeng2y. All rights reserved.
//

import Foundation

// MARK: - HTTP Request Task Types

/// HTTP 요청의 종류를 정의하는 열거형
///
/// 네트워크 요청 시 데이터를 어떤 방식으로 전송할지 결정합니다.
/// REST API의 다양한 요청 패턴을 타입-세이프하게 표현하여 컴파일 타임에 오류를 방지합니다.
///
/// **각 케이스별 사용 시나리오:**
/// - `requestPlain`: 단순 조회 (GET /users)
/// - `requestParameters`: 검색/필터링 (GET /users?name=홍길동)
/// - `requestJSONEncodable`: 데이터 생성/수정 (POST /users)
/// - `uploadMultipart`: 파일 업로드 (POST /feeds/image)
///
/// - Note: Sendable을 준수하여 동시성 환경에서 안전하게 사용할 수 있습니다.
public enum HTTPTask: Sendable {
    /// 파라미터가 없는 단순한 요청
    ///
    /// 주로 GET 요청에서 사용되며, URL 경로만으로 리소스를 식별하는 경우입니다.
    ///
    /// **사용 예시:**
    /// ```swift
    /// // GET /api/v1/users/123
    /// case fetchUser(id: Int):
    ///     return .requestPlain
    /// ```
    case requestPlain
    
    /// 딕셔너리를 URL 쿼리 파라미터로 변환하여 전송하는 요청
    ///
    /// GET 요청에서 검색, 필터링, 페이징 등에 사용됩니다.
    /// 딕셔너리의 key-value가 `?key=value&key2=value2` 형태로 URL에 추가됩니다.
    ///
    /// **사용 예시:**
    /// ```swift
    /// // GET /api/v1/users?page=1&limit=20
    /// case searchUsers(page: Int, limit: Int):
    ///     return .requestParameters([
    ///         "page": "\(page)",
    ///         "limit": "\(limit)"
    ///     ])
    /// ```
    ///
    /// - Note: 모든 값은 String 타입이어야 하며, URL 인코딩은 자동으로 처리됩니다.
    case requestParameters([String: String])
    
    /// Encodable 객체를 HTTP Body에 JSON으로 담아 전송하는 요청
    ///
    /// Swift 객체를 JSON으로 자동 변환하여 서버에 전송할 때 사용됩니다.
    /// POST, PUT, PATCH 요청에서 복잡한 데이터 구조를 전송할 때 주로 활용됩니다.
    ///
    /// **사용 예시:**
    /// ```swift
    /// struct CreateUserRequest: Encodable, Sendable {
    ///     let name: String
    ///     let email: String
    /// }
    ///
    /// // POST /api/v1/users
    /// case createUser(request: CreateUserRequest):
    ///     return .requestJSONEncodable(request)
    /// ```
    ///
    /// **자동 처리되는 기능:**
    /// - `JSONEncoder()`를 사용하여 객체를 JSON Data로 자동 변환
    /// - `Content-Type: application/json` 헤더 자동 추가
    ///
    /// - Note: 전달하는 객체는 반드시 `Encodable & Sendable`을 준수해야 합니다.
    case requestEncodable(any Encodable & Sendable)
    
    /// Multipart Form Data를 사용하여 파일을 업로드하는 요청
    ///
    /// 이미지, 동영상 등의 파일과 함께 텍스트 데이터를 전송할 때 사용됩니다.
    /// `Content-Type: multipart/form-data` 헤더가 자동으로 설정됩니다.
    ///
    /// **사용 예시:**
    /// ```swift
    /// // POST /api/v1/feeds (이미지 + 텍스트)
    /// case createFeed(image: Data, content: String):
    ///     return .uploadMultipart([
    ///         .image(image, name: "image"),
    ///         .text(content, name: "content")
    ///     ])
    ///
    /// // POST /api/v1/profile/image (이미지만)
    /// case updateProfileImage(image: Data):
    ///     return .uploadMultipart([
    ///         .image(image, name: "profileImage", fileName: "profile.jpg")
    ///     ])
    /// ```
    ///
    /// - Note: `MultipartFormItem`의 팩토리 메서드를 활용하면 편리하게 구성할 수 있습니다.
    case uploadMultipart([MultipartFormItem])
}
