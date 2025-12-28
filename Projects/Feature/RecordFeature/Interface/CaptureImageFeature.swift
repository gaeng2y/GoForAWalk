//
//  CaptureImageFeature.swift
//  RecordFeatureInterface
//
//  Created by Kyeongmo Yang on 8/3/25.
//  Copyright © 2025 com.gaeng2y. All rights reserved.
//

import CameraServiceInterface
import ComposableArchitecture
import CoreImage
import SwiftUI

@Reducer
public struct CaptureImageFeature {
    // MARK: - State

    @ObservableState
    public struct State: Equatable {
        @Presents public var cameraResult: PostFootstepFeature.State?
        public var viewFinderImage: Image?
        public var isFlipped: Bool = false
        public var flipDegree: Double = 0.0
        public var flipImage: Image?

        public init() {}
    }

    // MARK: - Action

    public enum Action: Equatable {
        case viewWillAppear

        case viewFinderUpdate(Image?)
        case flipImageRemove
        case moveToCameraResult(Image)

        case shutterTapped
        case dismissButtonTapped

        case flipDegreeUpdate

        case cameraResult(PresentationAction<PostFootstepFeature.Action>)
        case delegate(Delegate)

        public enum Delegate: Equatable {
            case savePhoto(Image)
        }
    }

    // MARK: - Dependencies

    let postFootstepFeature: PostFootstepFeature
    let reduce: (inout State, Action) -> Effect<Action>

    public init(
        postFootstepFeature: PostFootstepFeature,
        reduce: @escaping (inout State, Action) -> Effect<Action>
    ) {
        self.postFootstepFeature = postFootstepFeature
        self.reduce = reduce
    }

    public var body: some ReducerOf<Self> {
        Reduce(reduce)
            .ifLet(\.$cameraResult, action: \.cameraResult) {
                postFootstepFeature
            }
    }
}

// MARK: - CIImage Extension

public extension CIImage {
    var image: Image? {
        let ciContext = CIContext()
        guard let cgImage = ciContext.createCGImage(self, from: self.extent) else { return nil }
        return Image(decorative: cgImage, scale: 1, orientation: .up)
    }
}

// MARK: - Preview

extension CaptureImageFeature {
    public static func preview() -> Self {
        Self(
            postFootstepFeature: .preview()
        ) { state, action in
            switch action {
            case .viewWillAppear:
                return .none

            case let .viewFinderUpdate(image):
                state.viewFinderImage = image
                return .none

            case .flipImageRemove:
                state.flipImage = nil
                return .none

            case let .moveToCameraResult(image):
                state.cameraResult = PostFootstepFeature.State(resultImage: image)
                return .none

            case .shutterTapped:
                return .none

            case .dismissButtonTapped:
                return .none

            case .flipDegreeUpdate:
                state.flipDegree += 180
                return .none

            case .delegate:
                return .none

            case .cameraResult:
                return .none
            }
        }
    }
}
