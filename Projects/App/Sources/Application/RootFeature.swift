//
//  RootFeature.swift
//  Root
//
//  Created by Kyeongmo Yang on 5/5/25.
//  Copyright © 2025 com.gaeng2y. All rights reserved.
//

import Auth
import ComposableArchitecture
import KeyChainStore
import SignIn
import MainFeature

@Reducer
public struct RootFeature {
    @ObservableState
    public struct State {
        var isSignIn: Bool = false
        
        var signIn: SignInFeature.State = .init()
        var mainTab: MainTabFeature.State = .init()
        
        public init() {}
    }
    
    public enum Action {
        case signIn(SignInFeature.Action)
        case mainTab(MainTabFeature.Action)
        case logout
    }
    
    public init() {}
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .signIn(.isAlreadyAuthorized):
                state.isSignIn = true
                return .none

            case .mainTab(.delegate(.userDidLogout)):
                return .send(.logout)

            case .logout:
                state.isSignIn = false
                return .none

            default:
                return .none
            }
        }

        Scope(state: \.mainTab, action: \.mainTab) {
            MainTabFeature()
        }
        Scope(state: \.signIn, action: \.signIn) {
            SignInFeature()
        }
        .dependency(\.authClient, .liveValue)
    }
}
