//
//  FeedClient.swift
//  FeedServiceInterface
//
//  Created by Kyeongmo Yang on 6/10/25.
//  Copyright © 2025 com.gaeng2y. All rights reserved.
//

import Foundation

public struct FeedClient {
    public var fetchFootsteps: @Sendable () async throws -> [Footstep]
    public var deleteFootstep: @Sendable (Int) async throws -> Void
    public var createFootstep: @Sendable (CreateFootstepRequestDTO) async throws -> Void
    public var checkTodayAvailability: @Sendable () async throws -> TodayFootstepAvailability

    public init(
        fetchFootsteps: @escaping @Sendable () async throws -> [Footstep],
        deleteFootstep: @escaping @Sendable (Int) async throws -> Void,
        createFootstep: @escaping @Sendable (CreateFootstepRequestDTO) async throws -> Void,
        checkTodayAvailability: @escaping @Sendable () async throws -> TodayFootstepAvailability
    ) {
        self.fetchFootsteps = fetchFootsteps
        self.deleteFootstep = deleteFootstep
        self.createFootstep = createFootstep
        self.checkTodayAvailability = checkTodayAvailability
    }
}
