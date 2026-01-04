//
//  PostFootstepFeature.swift
//  RecordFeatureInterface
//
//  Created by Kyeongmo Yang on 8/3/25.
//  Copyright © 2025 com.gaeng2y. All rights reserved.
//

import ComposableArchitecture
import FeedServiceInterface
import SwiftUI

@Reducer
public struct PostFootstepFeature {
    // MARK: - State

    @ObservableState
    public struct State: Equatable {
        public var resultImage: Image
        public var todaysMessage: String = ""
        public let maxCharacterCount = 50
        public var isLoading: Bool = false
        @Presents public var alert: AlertState<Action.Alert>?

        public init(resultImage: Image) {
            self.resultImage = resultImage
        }
    }

    // MARK: - Action

    public enum Action: BindableAction, Equatable {
        case binding(BindingAction<State>)
        case cancelButtonTapped
        case saveButtonTapped
        case delegate(Delegate)
        case alert(PresentationAction<Alert>)
        case showErrorAlert(String)

        public enum Delegate: Equatable {
            case savePhotos(Image)
            case dismiss
        }

        public enum Alert: Equatable {
            case confirmError
        }
    }

    // MARK: - Reduce Closure

    let reduce: (inout State, Action) -> Effect<Action>

    public init(reduce: @escaping (inout State, Action) -> Effect<Action>) {
        self.reduce = reduce
    }

    public var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce(reduce)
            .ifLet(\.$alert, action: \.alert)
    }
}

// MARK: - Preview

extension PostFootstepFeature {
    public static func preview() -> Self {
        Self { state, action in
            switch action {
            case .binding(\.todaysMessage):
                if state.todaysMessage.count > state.maxCharacterCount {
                    state.todaysMessage = String(state.todaysMessage.prefix(state.maxCharacterCount))
                }
                return .none

            case .binding:
                return .none

            case .cancelButtonTapped:
                return .none

            case .saveButtonTapped:
                return .none

            case .delegate:
                return .none

            case .showErrorAlert:
                return .none

            case .alert:
                return .none
            }
        }
    }
}
