//
//  ProfileEndpoint.swift
//  UserService
//
//  Created by Kyeongmo Yang on 12/20/25.
//  Copyright © 2025 com.gaeng2y. All rights reserved.
//

import Foundation
import NetworkingInterface

enum ProfileEndpoint: Endpoint {
    case fetchProfile
    case withdraw
    case changeNickname(ChangeNicknameRequestDTO)
    
    var path: String {
        switch self {
        case .fetchProfile: "profile"
        case .withdraw: "users/me"
        case .changeNickname: "users/me/nickname"
        }
    }
    
    var method: NetworkingMethod {
        switch self {
        case .fetchProfile: .get
        case .withdraw: .delete
        case .changeNickname: .patch
        }
    }
    
    var authRequirement: AuthRequirement { .bearer }
    
    var task: HTTPTask {
        switch self {
        case .fetchProfile, .withdraw:
            return .requestPlain
        case .changeNickname(let dto):
            return .requestEncodable(dto)
        }
    }
}
