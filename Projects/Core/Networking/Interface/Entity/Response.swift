//
//  Response.swift
//  NetworkingInterface
//
//  Created by Kyeongmo Yang on 12/29/25.
//  Copyright © 2025 com.gaeng2y. All rights reserved.
//

import Foundation

public struct Response<T: Decodable & Sendable>: Decodable, Sendable {
    public let data: T
}
