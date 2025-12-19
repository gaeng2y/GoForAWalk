//
//  AuthEndpoint.swift
//  goforawalk
//
//  Created by Kyeongmo Yang on 4/28/25.
//

import AuthInterface
import Foundation
import NetworkingInterface

public enum AuthEndpoint: Endpoint, Sendable {
    case signIn(LoginType, SignInRequestDTO)
    
    public var path: String {
        switch self {
        case let .signIn(provider, _): "auth/login/oauth2/\(provider.rawValue)"
        }
    }
    
    public var method: NetworkingMethod {
        switch self {
        case .signIn: .post
        }
    }
    
    public var authRequirement: AuthRequirement {
        switch self {
        case .signIn: .none
        }
    }
    
    public var task: HTTPTask {
        switch self {
        case let .signIn(_, dto): .requestEncodable(dto)
        }
    }
}
