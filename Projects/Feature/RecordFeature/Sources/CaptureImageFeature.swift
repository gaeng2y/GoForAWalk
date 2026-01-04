//
//  CaptureImageFeature.swift
//  RecordFeature
//
//  Created by Kyeongmo Yang on 8/3/25.
//  Copyright © 2025 com.gaeng2y. All rights reserved.
//

import CameraServiceInterface
import ComposableArchitecture
import RecordFeatureInterface
import SwiftUI

public extension CaptureImageFeature {
    static func live(
        cameraClient: any CameraClient,
        postFootstepFeature: PostFootstepFeature
    ) -> Self {
        Self(
            postFootstepFeature: postFootstepFeature
        ) { state, action in
            @Dependency(\.dismiss) var dismiss

            switch action {
            // MARK: View Life Cycle
            case .viewWillAppear:
                return .run { send in
                    await cameraClient.start()

                    let imageStream = cameraClient.previewStream
                        .map { $0.image }

                    for await image in imageStream {
                        await send(.viewFinderUpdate(image))
                    }
                }

            // MARK: - Image
            case let .viewFinderUpdate(image):
                state.viewFinderImage = image
                return .none

            case .flipImageRemove:
                state.flipImage = nil
                return .none

            case let .moveToCameraResult(image):
                state.cameraResult = PostFootstepFeature.State(resultImage: image)
                return .none

            // MARK: - Button Tapped
            case .shutterTapped:
                return .run { send in
                    let resultImage = await cameraClient.takePhoto()
                    await send(.moveToCameraResult(resultImage))
                }

            case .dismissButtonTapped:
                cameraClient.stop()
                return .run { _ in await dismiss() }

            case .flipDegreeUpdate:
                state.flipDegree += 180
                return .none

            // MARK: - Delegate
            case .delegate:
                return .none

            case let .cameraResult(.presented(.delegate(.savePhotos(image)))):
                return .send(.delegate(.savePhoto(image)))

            case .cameraResult(.presented(.delegate(.dismiss))):
                return .run { _ in await dismiss() }

            case .cameraResult:
                return .none
            }
        }
    }
}
