//
//  FeedClient+Impl.swift
//  FeedServiceInterface
//
//  Created by Kyeongmo Yang on 6/10/25.
//  Copyright © 2025 com.gaeng2y. All rights reserved.
//

import FeedServiceInterface
import ComposableArchitecture
import Foundation
import Network

extension FeedClient: DependencyKey {
    public static let liveValue = FeedClient(
        fetchFootsteps: {
            let apiEndpoint = FeedEndpoint.fetchFootsteps()
            let response = try await NetworkProviderImpl.shared.request(apiEndpoint)
            return response.footsteps.map { $0.toDomain() }
        },
        deleteFootstep: { id in
            let endpoint = FeedEndpoint.deleteFoorstep(with: id)
            _ = try await NetworkProviderImpl.shared.request(endpoint)
        },
        createFootstep: { body in
            let endpoint = FeedEndpoint.createFootstep(with: body)
            _ = try await NetworkProviderImpl.shared.request(endpoint)
        }
    )
}

extension FeedClient: TestDependencyKey {
    public static var previewValue = Self(
        fetchFootsteps: {
            return [.mock, .mock, .mock, .mock, .mock]
        },
        deleteFootstep: unimplemented("\(Self.self).deleteFootstep"),
        createFootstep: unimplemented("\(Self.self).createFootstep")
    )
    
    public static let testValue = Self(
        fetchFootsteps: unimplemented("\(Self.self).fetchFootsteps"),
        deleteFootstep: unimplemented("\(Self.self).deleteFootstep"),
        createFootstep: unimplemented("\(Self.self).createFootstep")
    )
}

extension DependencyValues {
    public var feedClient: FeedClient {
        get { self[FeedClient.self] }
        set { self[FeedClient.self] = newValue }
    }
}
