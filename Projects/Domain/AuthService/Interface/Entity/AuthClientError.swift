//
//  AuthClientError.swift
//  AuthServiceInterface
//
//  Created by Kyeongmo Yang on 1/7/26.
//  Copyright © 2026 com.gaeng2y. All rights reserved.
//

import Foundation

public enum AuthClientError: LocalizedError {
    case missingIdToken
    case kakaoInternalError(Error)
    
    public var errorDescription: String? {
        switch self {
        case .missingIdToken:
            return "카카오 로그인에서 ID Token을 받아오지 못했습니다."
        case .kakaoInternalError(let error):
            return "카카오 SDK 에러: \(error.localizedDescription)"
        }
    }
}
