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
public struct FeedFeature {
    // MARK: - State
    
    @ObservableState
    public struct State: Equatable {
        public var footsteps: [Footstep] = []
        public var isLoading: Bool = false
        
        public init() {}
    }
    
    // MARK: - Action
    
    public enum Action {
        case onAppear
        case fetchFootstepsResponse([Footstep])
        case footstepCellMenuTapped(Int)
    }
    
    // MARK: - Reduce Closure
    
    let reduce: (inout State, Action) -> Effect<Action>
    
    public init(reduce: @escaping (inout State, Action) -> Effect<Action>) {
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
                state.footsteps = footsteps
                return .none
                
            case .footstepCellMenuTapped:
                return .none
            }
        }
    }
}
