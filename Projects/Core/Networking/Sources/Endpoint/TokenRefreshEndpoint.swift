//
//  TokenRefreshEndpoint.swift
//  NetworkingInterface
//
//  Created by Kyeongmo Yang on 12/20/25.
//  Copyright © 2025 com.gaeng2y. All rights reserved.
//

import Foundation
import NetworkingInterface

enum TokenRefreshEndpoint: Endpoint {
    case refresh(refreshToken: String)
    
    var path: String { "auth/token/refresh" }
    var method: NetworkingMethod { .post }
    var authRequirement: AuthRequirement { .none }
    var customHeaders: [String: String]? {
        switch self {
        case .refresh(let refreshToken):
            ["Authorization": "Bearer \(refreshToken)"]
        }
        
    }
    
    var task: HTTPTask {
        switch self {
        case .refresh: .requestPlain
        }
    }
}
