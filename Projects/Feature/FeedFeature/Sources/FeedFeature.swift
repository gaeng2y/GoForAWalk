//
//  FeedFeature.swift
//  FeedFeature
//
//  Created by Kyeongmo Yang on 6/10/25.
//  Copyright © 2025 com.gaeng2y. All rights reserved.
//

import FeedFeatureInterface
import FeedServiceInterface

public extension FeedFeature {
    static func live(feedClient: any FeedClient) -> Self {
        Self { state, action in
            switch action {
            case .onAppear:
                return .run { send in
                    let footsteps = try await feedClient.fetchFootsteps()
                    await send(.fetchFootstepsResponse(footsteps))
                }
                
            case .fetchFootstepsResponse(let footsteps):
                state.footsteps = footsteps
                return .none
                
            case .footstepCellMenuTapped(let id):
                return .run { send in
                    do {
                        try await feedClient.deleteFootstep(id: id)
                        await send(.onAppear)
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            }
        }
    }
}
