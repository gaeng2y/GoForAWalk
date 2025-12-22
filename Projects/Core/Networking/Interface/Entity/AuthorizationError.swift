//
//  AuthorizationError.swift
//  NetworkingInterface
//
//  Created by Kyeongmo Yang on 12/20/25.
//  Copyright © 2025 com.gaeng2y. All rights reserved.
//

import Foundation

public enum AuthorizationError: Error {
    case refreshTokenNotFound
    case invalidRequest
    case tokenRefreshFailed(Error)
}
