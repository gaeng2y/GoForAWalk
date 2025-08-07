//
//  TokenStore.swift
//  KeyChainStoreInterface
//
//  Created by Kyeongmo Yang on 5/8/25.
//  Copyright © 2025 com.gaeng2y. All rights reserved.
//

import Foundation

public protocol TokenStore {
    func validateToken() -> Bool
    func save(property: TokenProperty, value: String)
    func load(property: TokenProperty) -> String
    func delete(property: TokenProperty)
    func deleteAll()
}
