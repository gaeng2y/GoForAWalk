//
//  NetworkProvider.swift
//  NetworkInterface
//
//  Created by Kyeongmo Yang on 4/15/25.
//  Copyright © 2025 com.gaeng2y. All rights reserved.
//

import Foundation

public protocol NetworkProvider {
    func request<N: Networkable, T: Decodable>(_ endpoint: N) async throws -> T where N.Response == T
}
