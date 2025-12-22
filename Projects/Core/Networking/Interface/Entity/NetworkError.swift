//
//  NetworkError.swift
//  NetworkingInterface
//
//  Created by Kyeongmo Yang on 4/15/25.
//  Copyright © 2025 com.gaeng2y. All rights reserved.
//

import Foundation

public enum NetworkError: Error {
    /// 인증 실패 (HTTP 401)
    ///
    /// 토큰이 만료되었거나 유효하지 않을 때 발생합니다.
    /// 이 에러를 받으면 토큰 갱신 또는 재로그인 로직을 수행해야 합니다.
    case unauthorized
    
    /// 유효하지 않은 URL
    case invalidURL
    
    /// 허용되지 않는 HTTP 상태 코드 (e.g., 4xx, 5xx)
    /// - code: HTTP 상태 코드
    /// - data: 서버가 함께 보낸 에러 데이터 (있는 경우)
    case unacceptableStatusCode(code: Int, data: Data?)
    
    /// 응답 데이터 디코딩 실패
    case decodingFailed(Error)
    
    /// 요청 데이터 인코딩 실패
    case encodingFailed(Error)
    
    /// 네트워크 연결 실패 (e.g., 인터넷 없음, 타임아웃)
    case networkConnection(Error)
    
    /// 그 외 알 수 없는 에러
    case unknown(Error?)
    
    case missingContentType(acceptableTypes: [String])
    case unacceptableContentType(expected: [String], actual: String)
    case dataFileNotFound
    case dataFileReadFailed(url: URL)
}
