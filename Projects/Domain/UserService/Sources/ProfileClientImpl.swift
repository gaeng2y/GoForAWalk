//
//  ProfileClientImpl.swift
//  UserService
//
//  Created by Kyeongmo Yang on 12/20/25.
//  Copyright © 2025 com.gaeng2y. All rights reserved.
//

import Foundation
import NetworkingInterface
import UserServiceInterface

public final class ProfileClientImpl: ProfileClient {
    private let networkService: NetworkService
    
    public init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    public func fetchProfile() async throws -> Profile {
        let response: ProfileResponseDTO = try await networkService.request(ProfileEndpoint.fetchProfile)
        return response.toDomain()
    }
    
    public func withdrawUser() async throws {
        try await networkService.requestWithoutResponse(ProfileEndpoint.withdraw)
    }

    public func changeNickname(_ nickname: String) async throws {
        let dto = ChangeNicknameRequestDTO(nickname: nickname)
        try await networkService.requestWithoutResponse(ProfileEndpoint.changeNickname(dto))
    }
}
