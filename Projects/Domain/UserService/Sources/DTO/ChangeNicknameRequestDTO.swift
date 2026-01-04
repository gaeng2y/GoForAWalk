//
//  ChangeNicknameRequestDTO.swift
//  UserServiceInterface
//
//  Created by Kyeongmo Yang on 11/18/25.
//  Copyright © 2025 com.gaeng2y. All rights reserved.
//

import Foundation

public struct ChangeNicknameRequestDTO: Encodable, Sendable {
    let nickname: String
    
    public init(nickname: String) {
        self.nickname = nickname
    }
}
