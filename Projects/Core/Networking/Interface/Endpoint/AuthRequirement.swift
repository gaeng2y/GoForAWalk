//
//  AuthRequirement.swift
//  NetworkingInterface
//
//  Created by Kyeongmo Yang on 12/17/25.
//  Copyright © 2025 com.gaeng2y. All rights reserved.
//

import Foundation

public enum AuthRequirement: Sendable {
    /// 인증이 필요 없는 API
    ///
    /// 주로 로그인, 회원가입, 공개 컨텐츠 조회 등에서 사용됩니다.
    /// 이 케이스를 사용하면 인증 관련 헤더가 자동으로 추가되지 않습니다.
    case none
    
    /// 인증이 필요한 API
    ///
    /// 특정 인증 방식을 지정하여 해당하는 인증 헤더를 자동으로 추가합니다.
    /// 토큰을 String으로 받음
    case required(String)
}
