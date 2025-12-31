//
//  FeedFeature.swift
//  FeedFeature
//
//  Created by Kyeongmo Yang on 6/10/25.
//  Copyright © 2025 com.gaeng2y. All rights reserved.
//

import FeedFeatureInterface
import FeedServiceInterface
import RecordFeatureInterface

public extension FeedFeature {
    static func live(
        feedClient: any FeedClient,
        captureImageFeature: CaptureImageFeature
    ) -> Self {
        Self(
            captureImageFeature: captureImageFeature
        ) { state, action in
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

            case .floatingButtonTapped:
                return .run { send in
                    let availability = try await feedClient.checkTodayAvailability()
                    await send(.checkAvailabilityResponse(availability))
                }

            case .checkAvailabilityResponse(let availability):
                if availability.canCreateToday {
                    state.captureImage = CaptureImageFeature.State()
                } else {
                    state.showUnavailableAlert = true
                }
                return .none

            case .dismissUnavailableAlert:
                state.showUnavailableAlert = false
                return .none

            case .captureImage(.presented(.dismissButtonTapped)):
                state.captureImage = nil
                return .send(.onAppear)

            case .captureImage:
                return .none
            }
        }
    }
}
