//
//  AuthEndpoint.swift
//  goforawalk
//
//  Created by Kyeongmo Yang on 4/28/25.
//

import AuthServiceInterface
import Foundation
import NetworkingInterface

enum AuthEndpoint: Endpoint, Sendable {
    case signIn(LoginType, SignInRequestDTO)
    
    var path: String {
        switch self {
        case let .signIn(provider, _): "auth/login/oauth2/\(provider.rawValue)"
        }
    }
    
    var method: NetworkingMethod {
        switch self {
        case .signIn: .post
        }
    }
    
    var authRequirement: AuthRequirement {
        switch self {
        case .signIn: .none
        }
    }
    
    var task: HTTPTask {
        switch self {
        case let .signIn(_, dto): .requestEncodable(dto)
        }
    }
}
