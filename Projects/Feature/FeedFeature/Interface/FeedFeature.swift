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

@Reducer
public struct FeedFeature: @unchecked Sendable {
    // MARK: - State

    @ObservableState
    public struct State: Equatable {
        public enum ViewState: Equatable {
            case loading
            case empty
            case loaded([Footstep])
        }

        public var viewState: ViewState = .loading
        public var deleteTargetId: Int? = nil

        public init() {}

        public var footsteps: [Footstep] {
            if case .loaded(let items) = viewState {
                return items
            }
            return []
        }
    }

    // MARK: - Action

    public enum Action {
        case onAppear
        case fetchFootstepsResponse([Footstep])
        case footstepCellMenuTapped(Int)
        case deleteConfirmed
        case cancelDelete
    }

    // MARK: - Dependencies

    let reduce: (inout State, Action) -> Effect<Action>

    public init(
        reduce: @escaping (inout State, Action) -> Effect<Action>
    ) {
        self.reduce = reduce
    }

    public var body: some ReducerOf<Self> {
        Reduce(reduce)
    }
}

// MARK: - Preview

extension FeedFeature {
    public static func preview() -> Self {
        Self { state, action in
            switch action {
            case .onAppear:
                return .none

            case .fetchFootstepsResponse(let footsteps):
                state.viewState = footsteps.isEmpty ? .empty : .loaded(footsteps)
                return .none

            case .footstepCellMenuTapped(let id):
                state.deleteTargetId = id
                return .none

            case .deleteConfirmed:
                state.deleteTargetId = nil
                return .none

            case .cancelDelete:
                state.deleteTargetId = nil
                return .none
            }
        }
    }
}
