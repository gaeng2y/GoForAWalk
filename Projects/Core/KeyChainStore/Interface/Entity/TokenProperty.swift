//
//  TokenProperty.swift
//  KeyChainStoreInterface
//
//  Created by Kyeongmo Yang on 5/8/25.
//  Copyright © 2025 com.gaeng2y. All rights reserved.
//

import Foundation

public enum TokenProperty: String, CaseIterable, Sendable {
    case accessToken = "ACCESS-TOKEN"
    case refreshToken = "REFRESH-TOKEN"
}
