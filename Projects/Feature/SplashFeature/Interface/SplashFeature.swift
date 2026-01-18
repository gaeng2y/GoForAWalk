//
//  SplashFeature.swift
//  SplashFeatureInterface
//
//  Created by Kyeongmo Yang on 1/7/26.
//  Copyright © 2026 com.gaeng2y. All rights reserved.
//

import AuthServiceInterface
import ComposableArchitecture
import Foundation

@Reducer
public struct SplashFeature: @unchecked Sendable {
    // MARK: - State
    
    @ObservableState
    public struct State: Equatable {
        public enum Status: Equatable {
            case loading
            case authenticated
            case unauthenticated
        }
        
        public var status: Status = .loading
        
        public init() {}
    }
    
    // MARK: - Action
    
    public enum Action {
        case onAppear
        case tokenLoaded(Token?)
        case delegate(Delegate)
        
        public enum Delegate {
            case authenticated
            case unauthenticated
        }
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
