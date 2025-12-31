//
//  FeedFeature.swift
//  FeedFeatureInterface
//
//  Created by Kyeongmo Yang on 6/10/25.
//  Copyright © 2025 com.gaeng2y. All rights reserved.
//

import ComposableArchitecture
import FeedServiceInterface
import Foundation
import RecordFeatureInterface

@Reducer
public struct FeedFeature {
    // MARK: - State
    
    @ObservableState
    public struct State: Equatable {
        @Presents public var captureImage: CaptureImageFeature.State?
        public var footsteps: [Footstep] = []
        public var isLoading: Bool = false
        public var showUnavailableAlert: Bool = false
        
        public init() {}
    }
    
    // MARK: - Action
    
    public enum Action {
        case onAppear
        case fetchFootstepsResponse([Footstep])
        case footstepCellMenuTapped(Int)
        case floatingButtonTapped
        case checkAvailabilityResponse(TodayFootstepAvailability)
        case dismissUnavailableAlert
        case captureImage(PresentationAction<CaptureImageFeature.Action>)
    }
    
    // MARK: - Dependencies
    
    let captureImageFeature: CaptureImageFeature
    let reduce: (inout State, Action) -> Effect<Action>
    
    public init(
        captureImageFeature: CaptureImageFeature,
        reduce: @escaping (inout State, Action) -> Effect<Action>
    ) {
        self.captureImageFeature = captureImageFeature
        self.reduce = reduce
    }
    
    public var body: some ReducerOf<Self> {
        Reduce(reduce)
            .ifLet(\.$captureImage, action: \.captureImage) {
                captureImageFeature
            }
    }
}

// MARK: - Preview

extension FeedFeature {
    public static func preview() -> Self {
        Self(
            captureImageFeature: .preview()
        ) { state, action in
            switch action {
            case .onAppear:
                return .none
                
            case .fetchFootstepsResponse(let footsteps):
                state.footsteps = footsteps
                return .none
                
            case .footstepCellMenuTapped:
                return .none
                
            case .floatingButtonTapped:
                return .none
                
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
                
            case .captureImage:
                return .none
            }
        }
    }
}
