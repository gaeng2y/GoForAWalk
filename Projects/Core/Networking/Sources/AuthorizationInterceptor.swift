//
//  AuthorizationInterceptor.swift
//  Networking
//
//  Created by Kyeongmo Yang on 12/20/25.
//  Copyright © 2025 com.gaeng2y. All rights reserved.
//

import Alamofire
import Foundation
import KeyChainStoreInterface
import NetworkingInterface

// MARK: - AuthorizationInterceptor

/// 인증 헤더 자동 주입 및 토큰 갱신을 담당하는 Interceptor
///
/// **주요 기능:**
/// - `adapt`: 요청에 Authorization 헤더 자동 추가
/// - `retry`: 401 에러 시 토큰 갱신 후 재시도
public final class AuthorizationInterceptor: RequestInterceptor {
    
    // MARK: - Properties
    
    private let keychainStore: KeychainStore
    
    // MARK: - Initialization
    
    public init(keychainStore: KeychainStore) {
        self.keychainStore = keychainStore
    }
    
    // MARK: - RequestAdapter (Completion-based - Alamofire가 호출하는 메서드)

    public func adapt(
        _ urlRequest: URLRequest,
        for session: Session,
        completion: @escaping (Result<URLRequest, any Error>) -> Void
    ) {
        Task {
            do {
                let adaptedRequest = try await adapt(urlRequest, for: session)
                completion(.success(adaptedRequest))
            } catch {
                completion(.failure(error))
            }
        }
    }

    // MARK: - RequestAdapter (Async - 실제 로직)

    private func adapt(
        _ urlRequest: URLRequest,
        for session: Session
    ) async throws -> URLRequest {
        var request = urlRequest
        
        // 마커 헤더 확인: X-Requires-Auth가 "bearer"일 때만 토큰 추가
        guard request.value(forHTTPHeaderField: "X-Requires-Auth") == "bearer" else {
            return request
        }
        
        // 마커 헤더 제거
        request.setValue(nil, forHTTPHeaderField: "X-Requires-Auth")
        
        // 실제 Authorization 헤더 추가
        do {
            let accessToken = try await keychainStore.load(property: .accessToken)
            request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
            debugPrint("🔐 [Interceptor] Token loaded successfully")
        } catch {
            debugPrint("🔐 [Interceptor] Token load failed: \(error)")
            debugPrint("🔐 [Interceptor] URL: \(request.url?.absoluteString ?? "")")
        }
        
        
        return request
    }
    
    // MARK: - RequestRetrier (Completion-based - Alamofire가 호출하는 메서드)

    public func retry(
        _ request: Request,
        for session: Session,
        dueTo error: any Error,
        completion: @escaping (RetryResult) -> Void
    ) {
        Task {
            let result = await retry(request, for: session, dueTo: error)
            completion(result)
        }
    }

    // MARK: - RequestRetrier (Async - 실제 로직)

    private func retry(
        _ request: Request,
        for session: Session,
        dueTo error: Error
    ) async -> RetryResult {
        // 401 에러인지 확인
        guard let response = request.task?.response as? HTTPURLResponse,
              response.statusCode == 401 else {
            return .doNotRetryWithError(error)
        }
        
        // 토큰 갱신 시도
        do {
            try await refreshToken()
            return .retry
        } catch {
            return .doNotRetryWithError(error)
        }
    }
    
    // MARK: - Private Methods
    
    private func refreshToken() async throws {
        guard let refreshToken = try? await keychainStore.load(property: .refreshToken) else {
            throw AuthorizationError.refreshTokenNotFound
        }

        let endpoint = TokenRefreshEndpoint.refresh(refreshToken: refreshToken)
        let urlRequest = try endpoint.asURLRequest()

        let response = await AF.request(urlRequest)
            .validate(statusCode: 200..<300)
            .serializingDecodable(TokenRefreshResponseDTO.self)
            .response

        switch response.result {
        case .success(let tokenResponse):
            await keychainStore.save(property: .accessToken, value: tokenResponse.data.credentials.accessToken)
            await keychainStore.save(property: .refreshToken, value: tokenResponse.data.credentials.refreshToken)

        case .failure(let error):
            await keychainStore.deleteAll()
            throw AuthorizationError.tokenRefreshFailed(error)
        }
    }
}
