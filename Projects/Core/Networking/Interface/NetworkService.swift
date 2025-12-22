//
//  NetworkService.swift
//  NetworkingInterface
//
//  Created by Kyeongmo Yang on 12/17/25.
//  Copyright © 2025 com.gaeng2y. All rights reserved.
//

import Foundation

// MARK: - NetworkService Protocol

/// 네트워크 통신을 담당하는 서비스 프로토콜
///
/// **Clean Architecture에서의 역할:**
/// - Data Layer의 핵심 인터페이스로서 외부 API와의 통신을 추상화
/// - Repository 패턴에서 실제 데이터 조회를 위한 네트워크 계층 제공
/// - Domain Layer와 Infrastructure Layer 간의 의존성 역전 구현
///
/// **설계 원칙:**
/// - 프로토콜 기반 설계로 테스트 가능성과 확장성 보장
/// - Sendable 준수로 Swift 6 concurrency 안전성 제공
/// - Generic을 활용한 타입 안전성과 재사용성 극대화
///
/// **테스트 전략:**
/// ```swift
/// // Mock 구현체를 통한 단위 테스트
/// final class MockNetworkService: NetworkService {
///     func request<T: Decodable>(_ endpoint: any Endpoint) async throws -> T {
///         // 테스트용 Mock 데이터 반환
///     }
/// }
/// ```
///
/// - Note: 모든 구현체는 async/await를 통한 비동기 처리를 지원해야 합니다.
public protocol NetworkService: Sendable {
    /// API 요청을 비동기적으로 실행하고 응답을 Decodable 객체로 반환합니다.
    ///
    /// **핵심 기능:**
    /// - Endpoint 설정에 따른 HTTP 요청 생성 및 전송
    /// - 인증이 필요한 API의 경우 자동 헤더 추가
    /// - 서버 응답을 지정된 타입으로 자동 디코딩
    /// - 네트워크 오류 및 파싱 오류 처리
    ///
    /// **비동기 처리:**
    /// - Swift의 async/await 패턴을 사용하여 메인 스레드 블로킹 방지
    /// - UI 업데이트가 필요한 경우 호출부에서 @MainActor 처리 필요
    ///
    /// **타입 안전성:**
    /// - 제네릭 T를 통해 컴파일 타임에 반환 타입 검증
    /// - Decodable 프로토콜 준수를 통한 JSON 파싱 보장
    ///
    /// **실제 사용 예시:**
    /// ```swift
    /// // 사용자 정보 조회
    /// let user: UserModel = try await networkService.request(UserEndpoint.getProfile)
    ///
    /// // 에러 처리와 함께 사용
    /// do {
    ///     let feeds: [FeedModel] = try await networkService.request(FeedEndpoint.fetchFeeds)
    /// } catch {
    ///     print("API 호출 실패: \(error.localizedDescription)")
    /// }
    /// ```
    ///
    /// - Parameter endpoint: Endpoint 프로토콜을 구현한 API 엔드포인트 정의
    ///                      (baseURL, path, method, headers, task 등 요청 정보 포함)
    /// - Returns: 제네릭 T 타입(Decodable 준수)의 객체
    /// - Throws: NetworkError - 네트워크 통신이나 데이터 처리 중 발생하는 에러
    func request<T: Decodable>(_ endpoint: any Endpoint) async throws -> T
}
