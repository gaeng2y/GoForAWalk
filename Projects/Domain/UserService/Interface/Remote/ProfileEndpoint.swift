//
//  ProfileEndpoint.swift
//  UserService
//
//  Created by Kyeongmo Yang on 6/24/25.
//  Copyright © 2025 com.gaeng2y. All rights reserved.
//

import Auth
import Foundation
import NetworkInterface

public struct ProfileEndpoint {
    public static func fetchUserProfile() -> EndPoint<ProfileResponseDTO> {
        EndPoint(
            path: "profile",
            httpMethod: .get,
            headers: ["Authorization": "Bearer \(LocalAuthStoreImpl().loadToken().accessToken)"]
        )
    }
    
    public static func withdrawUser() -> EndPoint<EmptyData> {
        EndPoint(
            path: "users/me",
            httpMethod: .delete,
            headers: ["Authorization": "Bearer \(LocalAuthStoreImpl().loadToken().accessToken)"]
        )
    }
}
