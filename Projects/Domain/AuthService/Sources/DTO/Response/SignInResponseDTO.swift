//
//  SignInResponseDTO.swift
//  goforawalk
//
//  Created by Kyeongmo Yang on 4/28/25.
//

import AuthServiceInterface
import Foundation

struct SignInResponseDTO: Decodable {
    struct Credentials: Decodable {
        let accessToken: String
        let refreshToken: String
    }
    
    struct UserInfo: Decodable {
        let email: String?
        let nickname: String
    }
    
    let userId: Int
    let credentials: Credentials
    let userInfo: UserInfo
    
    init(
        userId: Int,
        credentials: Credentials,
        userInfo: UserInfo
    ) {
        self.userId = userId
        self.credentials = credentials
        self.userInfo = userInfo
    }
    
    func toDomain() -> (Token, User) {
        let token = Token(
            accessToken: credentials.accessToken,
            refreshToken: credentials.refreshToken
        )
        let user = User(
            nickname: userInfo.nickname,
            email: userInfo.email ?? ""
        )
        return (token, user)
    }
}
