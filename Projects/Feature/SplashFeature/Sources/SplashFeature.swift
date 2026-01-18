//
//  SplashFeature.swift
//  SplashFeature
//
//  Created by Kyeongmo Yang on 1/7/26.
//  Copyright © 2026 com.gaeng2y. All rights reserved.
//

import AuthServiceInterface
import ComposableArchitecture
import SplashFeatureInterface

public extension SplashFeature {
    static func live(authClient: any AuthClient) -> Self {
        Self { state, action in
            switch action {
            case .onAppear:
                return .run { send in
                    let token = await authClient.loadToken()
                    await send(.tokenLoaded(token))
                }
                
            case .tokenLoaded(let token):
                if token != nil {
                    state.status = .authenticated
                    return .send(.delegate(.authenticated))
                } else {
                    state.status = .unauthenticated
                    return .send(.delegate(.unauthenticated))
                }
                
            case .delegate:
                return .none
            }
        }
    }
}
