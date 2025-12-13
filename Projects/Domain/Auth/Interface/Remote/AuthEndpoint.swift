//
//  AuthEndpoint.swift
//  goforawalk
//
//  Created by Kyeongmo Yang on 4/28/25.
//

import Foundation
import NetworkingInterface

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

    public static func refreshToken(refreshToken: String) -> EndPoint<SignInResponseDTO> {
        EndPoint(
            path: "auth/token/refresh",
            httpMethod: .post,
            headers: ["Authorization": "Bearer \(refreshToken)"]
        )
    }
}
