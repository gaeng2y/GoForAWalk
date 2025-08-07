//
//  SignInRequestDTO.swift
//  goforawalk
//
//  Created by Kyeongmo Yang on 4/28/25.
//

import Foundation

public struct SignInRequestDTO: Encodable, Equatable {
    let idToken: String
    
    public init(idToken: String) {
        self.idToken = idToken
    }
}

public extension SignInRequestDTO {
    static let mock = Self(idToken: "ABCD-EJEO-KENLW_DKFLS")
}
