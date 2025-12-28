//
//  SignInFeature.swift
//  SignInInterface
//
//  Created by Kyeongmo Yang on 5/11/25.
//  Copyright © 2025 com.gaeng2y. All rights reserved.
//

import AuthServiceInterface
import AuthenticationServices
import ComposableArchitecture
import Foundation

@Reducer
public struct SignInFeature {
    // MARK: - State
    
    @ObservableState
    public struct State: Equatable {
        public var isLoading: Bool = false
        @Presents public var alert: AlertState<Action.Alert>?
        
        public init() {}
    }
    
    // MARK: - Action
    
    public enum Action {
        case alert(PresentationAction<Alert>)
        case checkAuthorization
        case isAlreadyAuthorized
        case kakaoSignInButtonTapped
        case signInWithKakakoResponse(Token, User)
        case signInWithKakaoError(Error)
        case signInWithAppleCredential(ASAuthorization)
        case signInWithAppleError(Error)
        
        @CasePathable
        public enum Alert: Equatable {
            case messageReceived(String)
        }
    }
    
    // MARK: - Reduce Closure
    
    let reduce: (inout State, Action) -> Effect<Action>
    
    public init(reduce: @escaping (inout State, Action) -> Effect<Action>) {
        self.reduce = reduce
    }
    
    public var body: some ReducerOf<Self> {
        Reduce(reduce)
            .ifLet(\.$alert, action: \.alert)
    }
}
