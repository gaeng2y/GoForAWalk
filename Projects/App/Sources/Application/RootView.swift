//
//  RootView.swift
//  Root
//
//  Created by Kyeongmo Yang on 5/5/25.
//  Copyright © 2025 com.gaeng2y. All rights reserved.
//

import ComposableArchitecture
import MainFeatureInterface
import SignInInterface
import SwiftUI

public struct RootView: View {
    let store: StoreOf<RootFeature>

    public init(store: StoreOf<RootFeature>) {
        self.store = store
    }

    public var body: some View {
        Group {
            if store.isSignIn {
                MainTabView(
                    store: store.scope(state: \.mainTab, action: \.mainTab)
                )
            } else {
                SignInView(
                    store: store.scope(state: \.signIn, action: \.signIn)
                )
            }
        }
        .onAppear {
            store.send(.onAppear)
        }
    }
}
