//
//  MainTabView.swift
//  MainFeature
//
//  Created by Kyeongmo Yang on 5/14/25.
//  Copyright © 2025 com.gaeng2y. All rights reserved.
//

import ComposableArchitecture
import DesignSystem
import FeedFeature
import ProfileFeature
import RecordFeature
import SwiftUI

public struct MainTabView: View {
    private let store: StoreOf<MainTabFeature>
    
    public init(store: StoreOf<MainTabFeature>) {
        self.store = store
    }
    
    public var body: some View {
        TabView {
            Tab(
                MainTab.home.title,
                systemImage: MainTab.home.imageName
            ) {
                NavigationStack {
                    FeedListView(
                        store: store.scope(
                            state: \.feed,
                            action: \.feed
                        )
                    )
                }
            }
            
            Tab(MainTab.record.title, systemImage: MainTab.record.imageName) {
                Text("등록")
                    .onAppear {
                        store.send(.presentCaptureImage)
                    }
            }
            
            Tab(
                MainTab.profile.title,
                systemImage: MainTab.profile.imageName
            ) {
                ProfileView(
                    store: store.scope(
                        state: \.profile,
                        action: \.profile
                    )
                )
            }
        }
        .fullScreenCover(store: self.store.scope(
            state: \.$usingCamera,
            action: \.usingCamera)
        ) { store in
            NavigationStack {
                CaptureImageView(store: store)
            }
        }
        .transaction { transaction in
            transaction.disablesAnimations = store.disableDismissAnimation
        }
    }
}

#Preview {
    MainTabView(store: Store(initialState: MainTabFeature.State()) {
        MainTabFeature()
    })
}
