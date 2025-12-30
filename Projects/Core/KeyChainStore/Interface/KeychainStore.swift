//
//  KeychainStore.swift
//  KeyChainStore
//
//  Created by Kyeongmo Yang on 12/20/25.
//  Copyright © 2025 com.gaeng2y. All rights reserved.
//

import Foundation

public protocol KeychainStore: Sendable {
    func save(property: TokenProperty, value: String) async
    func load(property: TokenProperty) async throws(KeychainError) -> String
    func deleteAll() async
}
