//
//  AuthService.swift
//  AuthServiceInterface
//
//  Created by Kyeongmo Yang on 4/22/25.
//  Copyright © 2025 com.gaeng2y. All rights reserved.
//

import Foundation

public protocol AuthClient: Sendable {
    /// 카카오 OAuth 로그인 수행
    func signInWithKakao() async throws -> (Token, User)
    /// Apple OAuth 로그인 수행
    @MainActor func signInWithApple() async throws -> (Token, User)
    /// 토큰 저장
    func saveToken(_ token: Token) async
    /// 토큰 로드
    func loadToken() async -> Token?
    /// 모든 토큰 삭제
    func deleteAll() async
}
