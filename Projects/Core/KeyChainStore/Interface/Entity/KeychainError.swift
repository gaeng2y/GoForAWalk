//
//  KeychainError.swift
//  KeyChainStore
//
//  Created by Kyeongmo Yang on 12/20/25.
//  Copyright © 2025 com.gaeng2y. All rights reserved.
//

import Foundation

public enum KeychainError: Error, Sendable {
    case itemNotFound
    case unexpectedData
    case unhandledError(OSStatus)
}
