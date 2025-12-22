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
