//
//  KeyChainStore.swift
//  KeyChainStoreInterface
//
//  Created by Kyeongmo Yang on 5/8/25.
//  Copyright © 2025 com.gaeng2y. All rights reserved.
//

import Foundation
import KeyChainStoreInterface

public final class KeyChainStore: TokenStore {
    public static let shared = KeyChainStore()
    
    private init() {}
    
    public func validateToken() -> Bool {
        load(property: .accessToken).isEmpty == false
    }
    
    public func save(property: TokenProperty, value: String) {
        let query: NSDictionary = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: property.rawValue,
            kSecValueData: value.data(using: .utf8, allowLossyConversion: false) ?? .init()
        ]
        
        SecItemDelete(query)
        SecItemAdd(query, nil)
    }
    
    public func load(property: TokenProperty) -> String {
        let query: NSDictionary = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: property.rawValue,
            kSecReturnData: kCFBooleanTrue!,
            kSecMatchLimit: kSecMatchLimitOne
        ]
        
        var dataTypeRef: AnyObject?
        
        let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        
        if status == errSecSuccess {
            guard let data = dataTypeRef as? Data else { return "" }
            return String(data: data, encoding: .utf8) ?? ""
        }
        
        return ""
    }
    
    public func delete(property: KeyChainStoreInterface.TokenProperty) {
        let query: NSDictionary = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: property.rawValue
        ]
        
        SecItemDelete(query)
    }
    
    public func deleteAll() {
        TokenProperty.allCases.forEach {
            delete(property: $0)
        }
    }
}
