//
//  EndPoint.swift
//  NetworkInterface
//
//  Created by Kyeongmo Yang on 4/15/25.
//  Copyright © 2025 com.gaeng2y. All rights reserved.
//

import Foundation

public protocol Networkable: Requestable, Responsable {}

public struct EndPoint<R>: Networkable {
    public typealias Response = R
    
    public var path: String
    public var httpMethod: HTTPMethod
    public var queryParameters: Encodable?
    public var bodyParameters: Encodable?
    public var headers: [String : String]?
    
    public init(
        path: String,
        httpMethod: HTTPMethod,
        queryParameters: Encodable? = nil,
        bodyParameters : Encodable? = nil,
        headers: [String : String]? = nil
    ) {
        self.path = path
        self.httpMethod = httpMethod
        self.queryParameters = queryParameters
        self.bodyParameters = bodyParameters
        self.headers = headers
    }
}
