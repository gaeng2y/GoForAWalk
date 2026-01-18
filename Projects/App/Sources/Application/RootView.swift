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
import SplashFeatureInterface
import SwiftUI

public struct RootView: View {
    let store: StoreOf<RootFeature>

    public init(store: StoreOf<RootFeature>) {
        self.store = store
    }

    public var body: some View {
        Group {
            switch store.destination {
            case .splash:
                SplashView(
                    store: store.scope(state: \.splash, action: \.splash)
                )

            case .signIn:
                SignInView(
                    store: store.scope(state: \.signIn, action: \.signIn)
                )

            case .mainTab:
                MainTabView(
                    store: store.scope(state: \.mainTab, action: \.mainTab)
                )
            }
        }
        .onAppear {
            store.send(.onAppear)
        }
    }
}
