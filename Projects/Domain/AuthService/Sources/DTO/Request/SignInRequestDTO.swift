//
//  SignInRequestDTO.swift
//  goforawalk
//
//  Created by Kyeongmo Yang on 4/28/25.
//

import Foundation

struct SignInRequestDTO: Encodable, Equatable, Sendable {
    let idToken: String
}

extension SignInRequestDTO {
    static let mock = Self(idToken: "ABCD-EJEO-KENLW_DKFLS")
}
