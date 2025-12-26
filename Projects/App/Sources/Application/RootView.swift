//
//  RootView.swift
//  Root
//
//  Created by Kyeongmo Yang on 5/5/25.
//  Copyright © 2025 com.gaeng2y. All rights reserved.
//

import ComposableArchitecture
import MainFeatureInterface
import SignIn
import SwiftUI

public struct RootView: View {
    public let store: StoreOf<RootFeature>
    
    public init(store: StoreOf<RootFeature>) {
        self.store = store
    }
    
    public var body: some View {
        MainTabView(store: store.scope(state: \.mainTab, action: \.mainTab))
//        if store.state.isSignIn {
//            
//        } else {
//            SignInView(store: store.scope(state: \.signIn, action: \.signIn))
//                .onAppear {
//                    store.send(.signIn(.checkAuthorization))
//                }
//        }
    }
}

#Preview {
    RootView(
        store: Store(initialState: RootFeature.State()) {
            RootFeature()
        }
    )
}
