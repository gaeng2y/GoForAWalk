//
//  Notification+Name.swift
//  Util
//
//  Created by Kyeongmo Yang on 12/31/25.
//  Copyright © 2025 com.gaeng2y. All rights reserved.
//

import Foundation

public extension Notification.Name {
    /// Refresh Token 갱신 실패 시 강제 로그아웃이 필요함을 알리는 알림
    ///
    /// 다음 에러 코드 발생 시 발송됨:
    /// - A_4102: Refresh token expired
    /// - A_4103: Refresh token mismatch
    /// - A_4140: Refresh token missing/malformed
    static let forceLogoutRequired = Notification.Name("forceLogoutRequired")
}
