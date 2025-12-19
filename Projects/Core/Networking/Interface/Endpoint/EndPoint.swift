//
//  EndPoint.swift
//  NetworkingInterface
//
//  Created by Kyeongmo Yang on 4/15/25.
//  Copyright © 2025 com.gaeng2y. All rights reserved.
//

import Alamofire
import Foundation

public protocol Endpoint: URLRequestConvertible, Sendable {
    /// API 서버의 기본 URL
    ///
    /// 모든 API 요청의 시작점이 되는 서버 주소입니다.
    /// 개발/스테이징/프로덕션 환경에 따라 다른 URL을 반환할 수 있습니다.
    ///
    /// - 프로덕션: `https://api.example.com`
    var baseURL: URL { get }
    
    /// API 엔드포인트의 경로
    ///
    /// baseURL 뒤에 붙는 리소스 경로입니다.
    /// RESTful API 원칙에 따라 리소스 중심으로 구성하는 것이 좋습니다.
    ///
    /// **예시:**
    /// - 사용자 조회: `/users/123`
    /// - 게시물 목록: `/posts?page=1`
    /// - 파일 업로드: `/uploads/images`
    var path: String { get }
    
    /// HTTP 메서드 (GET, POST, PUT, DELETE 등)
    ///
    /// 수행하려는 작업의 의도를 나타냅니다:
    /// - `GET`: 데이터 조회 (읽기 전용)
    /// - `POST`: 새로운 리소스 생성
    /// - `PUT`: 기존 리소스 전체 수정
    /// - `PATCH`: 기존 리소스 부분 수정
    /// - `DELETE`: 리소스 삭제
    var method: NetworkingMethod { get }
    
    /// 인증 요구사항 정의
    ///
    /// 이 API 엔드포인트가 어떤 인증을 필요로 하는지 명시합니다.
    /// 인증 헤더는 AuthorizationInterceptor에서 자동으로 추가됩니다.
    ///
    /// **예시:**
    /// - 로그인 API: `.none` (인증 불필요)
    /// - 사용자 정보 API: `.bearer` (Bearer 토큰 필요)
    var authRequirement: AuthRequirement { get }
    
    /// 커스텀 HTTP 헤더 정보 (선택사항)
    ///
    /// 인증 헤더를 제외한 추가 헤더들을 정의합니다.
    /// 인증 헤더는 authRequirement에 따라 자동으로 추가되므로 여기서는 제외합니다.
    ///
    /// **일반적인 커스텀 헤더들:**
    /// - `Content-Type`: 요청 본문의 형식
    /// - `Accept`: 응답으로 받을 형식
    /// - `User-Agent`: 클라이언트 식별 정보
    /// - `X-Custom-Header`: 프로젝트별 커스텀 헤더
    var customHeaders: [String: String]? { get }
    
    /// HTTP 요청 작업 타입
    ///
    /// 요청에 포함할 데이터와 그 형식을 정의합니다.
    /// HTTPTask 열거형의 케이스 중 하나를 반환합니다.
    /// 기본값은 .requestPlain (파라미터 없는 요청)입니다.
    var task: HTTPTask { get }
}

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
public extension Endpoint {
    /// 기본 baseURL 값 (Info.plist에서 가져옴)
    ///
    /// 특별한 경우 잘넣어놓겠지만 없다면
    /// https://api-goforawalk.haero77.org/ 를 넣어주도록 적용
    var baseURL: URL {
        let baseURLPath = Bundle.main.infoDictionary?["BASE_URL"] as? String ?? "https://api-goforawalk.haero77.org/"
        let baseURLPrefixPath = Bundle.main.infoDictionary?["BASE_URL_PREFIX"] as? String ?? "api/v1"
        return URL(string: baseURLPath + baseURLPrefixPath)!
    }
    
    /// 기본 커스텀 헤더 값 (nil)
    ///
    /// 특별한 헤더가 필요 없는 엔드포인트에서 사용됩니다.
    /// 필요한 경우 각 엔드포인트에서 이 값을 override할 수 있습니다.
    var customHeaders: [String: String]? { nil }
    
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
            throw AFError.invalidURL(url: url)
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
            throw AFError.invalidURL(url: url)
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
                // 인코딩 실패 시 에러 처리 (Alamofire 에러나 커스텀 에러로 래핑)
                throw AFError.parameterEncodingFailed(reason: .jsonEncodingFailed(error: error))
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
