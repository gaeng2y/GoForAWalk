//
//  AuthEndpoint.swift
//  goforawalk
//
//  Created by Kyeongmo Yang on 4/28/25.
//

import Foundation
import NetworkInterface

public struct AuthEndpoint {
    public static func signIn(
        provider: LoginType,
        _ requestDTO: SignInRequestDTO
    ) -> EndPoint<SignInResponseDTO> {
        return EndPoint(
            path: "auth/login/oauth2/\(provider.rawValue)",
            httpMethod: .post,
            bodyParameters: requestDTO
        )
    }
}
