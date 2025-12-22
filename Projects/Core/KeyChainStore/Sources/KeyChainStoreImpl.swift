//
//  KeychainStoreImpl.swift
//  KeyChainStore
//
//  Created by Kyeongmo Yang on 12/20/25.
//  Copyright © 2025 com.gaeng2y. All rights reserved.
//

import Foundation
import KeyChainStoreInterface

public struct KeychainStoreImpl: KeychainStore {
    public init() {}
    
    public func save(
        property: TokenProperty,
        value: String
    ) {
       let query: NSDictionary = [
           kSecClass: kSecClassGenericPassword,
           kSecAttrAccount: property.rawValue,
           kSecValueData: value.data(using: .utf8, allowLossyConversion: false) ?? .init()
       ]
       
       SecItemDelete(query)
       SecItemAdd(query, nil)
   }
   
    public func load(
        property: TokenProperty
    ) throws(KeychainError) -> String {
       let query: NSDictionary = [
           kSecClass: kSecClassGenericPassword,
           kSecAttrAccount: property.rawValue,
           kSecReturnData: kCFBooleanTrue!,
           kSecMatchLimit: kSecMatchLimitOne
       ]
       
       var dataTypeRef: AnyObject?
       
        let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        
        switch status {
        case errSecSuccess:
            guard let data = dataTypeRef as? Data,
                  let value = String(data: data, encoding: .utf8) else {
                throw .unexpectedData
            }
            return value
        case errSecItemNotFound:
            throw .itemNotFound
        default:
            throw .unhandledError(status)
        }
   }
   
   public func deleteAll() {
       TokenProperty.allCases.forEach {
           delete(property: $0)
       }
   }
}

private extension KeychainStoreImpl {
    private func delete(property: TokenProperty) {
        let query: NSDictionary = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: property.rawValue
        ]
        
        SecItemDelete(query)
    }
}
