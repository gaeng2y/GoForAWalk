//
//  ProfileClient+Impl.swift
//  UserService
//
//  Created by Kyeongmo Yang on 6/24/25.
//  Copyright © 2025 com.gaeng2y. All rights reserved.
//

import UserServiceInterface
import ComposableArchitecture
import Foundation
import Networking

extension ProfileClient: DependencyKey {
    public static var liveValue: ProfileClient = .init(
        fetchProfile: {
            let endpoint = ProfileEndpoint.fetchUserProfile()
            let response = try await NetworkProviderImpl.shared.request(endpoint)
            return response.toDomain()
        },
        withdrawUser: {
            let endpoint = ProfileEndpoint.withdrawUser()
            let response = try await NetworkProviderImpl.shared.request(endpoint)
            print(response)
        },
        changeNickname: { nickname in
            let dto = ChangeNicknameRequestDTO(nickname: nickname)
            let endpoint = ProfileEndpoint.changeNickname(with: dto)
            let response = try await NetworkProviderImpl.shared.request(endpoint)
            print(response)
        }
    )
}

extension ProfileClient: TestDependencyKey {
    public static var previewValue: ProfileClient = .init(
        fetchProfile: unimplemented("\(Self.self).fetchProfile"),
        withdrawUser: unimplemented("\(Self.self).withdrawUser"),
        changeNickname: unimplemented("\(Self.self).changeNickname")
    )
    
    public static let testValue: ProfileClient = .init(
        fetchProfile: unimplemented("\(Self.self).fetchProfile"),
        withdrawUser: unimplemented("\(Self.self).withdrawUser"),
        changeNickname: unimplemented("\(Self.self).changeNickname")
    )
}

extension DependencyValues {
    public var profileClient: ProfileClient {
        get { self[ProfileClient.self] }
        set { self[ProfileClient.self] = newValue }
    }
}
