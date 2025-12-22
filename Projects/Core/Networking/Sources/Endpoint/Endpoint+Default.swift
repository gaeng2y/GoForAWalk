//
//  Endpoint+Default.swift
//  Networking
//
//  Created by Kyeongmo Yang on 12/22/25.
//  Copyright © 2025 com.gaeng2y. All rights reserved.
//

import Alamofire
import Foundation
import NetworkingInterface

// MARK: - Default Implementations

/// Endpoint 프로토콜의 기본 구현을 제공하는 익스텐션
///
/// 대부분의 엔드포인트에서 공통으로 사용되는 기본값들을 정의하고,
/// Alamofire와 호환되도록 URLRequest로 변환하는 핵심 로직을 구현합니다.
///
/// **주요 기능:**
/// - 기본값 제공 (customHeaders, task)
/// - URLRequest 생성 및 설정
/// - 다양한 HTTPTask 타입 처리
///
/// - Note: Bearer 인증 헤더는 AuthorizationInterceptor에서 자동으로 처리됩니다.
extension Endpoint {
    /// Endpoint를 Alamofire가 사용할 수 있는 URLRequest로 변환합니다.
    ///
    /// 이 메서드는 URLRequestConvertible 프로토콜의 요구사항을 구현하며,
    /// 다음과 같은 단계로 URLRequest를 생성합니다:
    ///
    /// **처리 순서:**
    /// 1. URL 구성 (baseURL + path)
    /// 2. 쿼리 파라미터 처리 (.requestParameters의 경우)
    /// 3. URLRequest 기본 설정 (method, headers)
    /// 4. Body 데이터 처리 (task 타입에 따라)
    ///
    /// - Returns: 완전히 구성된 URLRequest 객체
    /// - Throws: URL 생성 실패 시 AFError.invalidURL
    ///
    /// **지원되는 HTTPTask 타입:**
    /// - `.requestPlain`: 파라미터 없는 단순 요청
    /// - `.requestParameters`: 쿼리 파라미터가 포함된 요청
    /// - `.requestEncodable`: Encodable 객체를 JSON Body로 전송
    /// - `.uploadMultipart`: URL만 생성, 실제 업로드는 NetworkService에서 별도 처리
    func asURLRequest() throws -> URLRequest {
        // 1. 기본 URL과 경로를 결합하여 완전한 URL 생성
        let url = baseURL.appendingPathComponent(path)
        
        // 2. URLComponents를 사용하여 쿼리 파라미터 처리 준비
        guard var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            throw NetworkError.invalidURL
        }
        
        // 3. 쿼리 파라미터가 있는 경우 URL에 추가
        if case .requestParameters(let parameters) = task {
            urlComponents.queryItems = parameters.map { key, value in
                URLQueryItem(name: key, value: value)
            }
        }
        
        var httpHeaders: HTTPHeaders?
        // 4. HTTP 헤더 설정 (Alamofire의 HTTPHeaders 타입 사용)
        if let headers = self.customHeaders {
            httpHeaders = HTTPHeaders(headers)
        }
        
        // 5. 최종 URL 검증 및 URLRequest 생성
        guard let finalURL = urlComponents.url else {
            throw NetworkError.invalidURL
        }
        
        var request = try URLRequest(
            url: finalURL,
            method: method.httpMethod,
            headers: httpHeaders
        )
        
        // 6. 인증이 필요한 경우 마커 헤더 추가 (Interceptor에서 처리)
        if case .bearer = authRequirement {
            request.headers.add(name: "X-Requires-Auth", value: "bearer")
        }
        
        // 7. HTTP Body 데이터 처리 (task 타입에 따라 분기)
        switch task {
        case .requestEncodable(let body):
            // Encodable & Sendable 객체를 JSON Data로 인코딩
            // Content-Type 헤더가 없는 경우에만 JSON으로 자동 설정
            do {
                request.httpBody = try JSONEncoder().encode(body)
                if request.headers["Content-Type"] == nil {
                    request.headers.add(name: "Content-Type", value: "application/json")
                }
            } catch {
                // 인코딩 실패 시 에러 처리
                throw NetworkError.encodingFailed(error)
            }
            
        case .requestPlain, .requestParameters:
            // Body 데이터가 필요 없는 요청 타입들
            break
            
        case .uploadMultipart:
            // Multipart는 Alamofire의 upload(multipartFormData:)를 사용해야 함
            // NetworkService에서 별도 처리하므로 여기서는 URL만 생성
            break
        }
        
        return request
    }
}

extension NetworkingMethod {
    var httpMethod: HTTPMethod {
        switch self {
        case .get: .get
        case .post: .post
        case .put: .put
        case .patch: .patch
        case .delete: .delete
        }
    }
}
