//
//  HTTPMethod.swift
//  NetworkingInterface
//
//  Created by Kyeongmo Yang on 12/19/25.
//  Copyright © 2025 com.gaeng2y. All rights reserved.
//

import Alamofire
import Foundation

public enum NetworkingMethod: String, Sendable {
    case get
    case post
    case put
    case patch
    case delete
}

extension NetworkingMethod {
    var httpMethod: HTTPMethod {
        switch self {
        case .get: .get
        case .post: .post
        case .put: .put
        case .patch: .patch
        case .delete: .delete
        }
    }
}
