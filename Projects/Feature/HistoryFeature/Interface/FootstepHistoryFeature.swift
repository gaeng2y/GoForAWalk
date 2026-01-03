//
//  HistoryFeature.swift
//  HistoryFeatureInterface
//
//  Created by Kyeongmo Yang on 1/3/26.
//  Copyright © 2026 com.gaeng2y. All rights reserved.
//

import ComposableArchitecture
import FeedServiceInterface
import Foundation

@Reducer
public struct FootstepHistoryFeature {
    // MARK: - State

    @ObservableState
    public struct State: Equatable {
        public var currentMonth: Date = .now
        public var selectedDate: Date? = .now
        public var footsteps: [Footstep] = []
        public var selectedFootstep: Footstep? = nil
        public var isLoading: Bool = false
        public var showDatePicker: Bool = false
        public var deleteTargetId: Int? = nil

        public init() {}

        public var footstepDates: Set<String> {
            Set(footsteps.compactMap { $0.date })
        }
    }

    // MARK: - Action

    public enum Action: BindableAction {
        case binding(BindingAction<State>)
        case onAppear
        case selectDate(Date)
        case changeMonth(Date)
        case fetchCalendarFootstepsResponse([Footstep])
        case fetchError(String)
        case deleteMenuTapped(Int)
        case deleteConfirmed
        case cancelDelete
        case deleteResponse
    }

    // MARK: - Dependencies

    let reduce: (inout State, Action) -> Effect<Action>

    public init(
        reduce: @escaping (inout State, Action) -> Effect<Action>
    ) {
        self.reduce = reduce
    }

    public var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce(reduce)
    }
}

// MARK: - Preview

extension FootstepHistoryFeature {
    public static func preview() -> Self {
        Self { state, action in
            switch action {
            case .binding:
                return .none

            case .onAppear:
                return .none

            case .selectDate(let date):
                state.selectedDate = date
                state.selectedFootstep = state.footsteps.first {
                    guard let footstepDate = $0.date else { return false }
                    let formatter = DateFormatter()
                    formatter.dateFormat = "yyyy-MM-dd"
                    return footstepDate == formatter.string(from: date)
                }
                return .none

            case .changeMonth(let date):
                state.currentMonth = date
                return .none

            case .fetchCalendarFootstepsResponse(let footsteps):
                state.footsteps = footsteps
                state.isLoading = false
                return .none

            case .fetchError:
                state.isLoading = false
                return .none

            case .deleteMenuTapped(let id):
                state.deleteTargetId = id
                return .none

            case .deleteConfirmed:
                if let targetId = state.deleteTargetId {
                    state.footsteps.removeAll { $0.id == targetId }
                    if state.selectedFootstep?.id == targetId {
                        state.selectedFootstep = nil
                    }
                }
                state.deleteTargetId = nil
                return .none

            case .cancelDelete:
                state.deleteTargetId = nil
                return .none

            case .deleteResponse:
                return .none
            }
        }
    }
}
