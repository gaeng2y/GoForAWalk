//
//  ResponseData.swift
//  NetworkingInterface
//
//  Created by Kyeongmo Yang on 5/6/25.
//  Copyright © 2025 com.gaeng2y. All rights reserved.
//

import Foundation

public struct EmptyData: Decodable, Equatable {
    public init() {}
}

public struct ResponseData<T: Decodable>: Decodable {
    public let data: T
}
