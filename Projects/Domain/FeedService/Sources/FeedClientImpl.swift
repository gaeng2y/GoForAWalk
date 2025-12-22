//
//  FeedClientImpl.swift
//  FeedServiceInterface
//
//  Created by Kyeongmo Yang on 6/10/25.
//  Copyright © 2025 com.gaeng2y. All rights reserved.
//

import FeedServiceInterface
import Foundation
import NetworkingInterface

public final class FeedClientImpl: FeedClient {
    private let networkService: NetworkService
    
    public init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    public func fetchFootsteps() async throws -> [Footstep] {
        let response: FetchFootstepsResponseDTO = try await networkService.request(FeedEndpoint.fetchFootsteps)
        return response.footsteps.map { $0.toDomain() }
    }
    
    public func deleteFootstep(id: Int) async throws {
        let _: EmptyData = try await networkService.request(FeedEndpoint.deleteFootstep(id: id))
    }
    
    public func createFootstep(data: Data, content: String, fileName: String) async throws {
        let dto = CreateFootstepRequestDTO(
            data: data,
            content: content,
            fileName: fileName
        )
        let _: CreateFootstepResponseDTO = try await networkService.request(FeedEndpoint.createFootstep(dto: dto))
    }
    
    public func checkTodayAvailability() async throws -> TodayFootstepAvailability {
        let response: TodayFootstepAvailabilityResponseDTO = try await networkService.request(FeedEndpoint.checkTodayAvailability)
        return response.toDomain()
    }
}
