//
//  MainTabView.swift
//  MainFeatureInterface
//
//  Created by Kyeongmo Yang on 5/14/25.
//  Copyright © 2025 com.gaeng2y. All rights reserved.
//

import ComposableArchitecture
import DesignSystem
import FeedFeatureInterface
import ProfileFeatureInterface
import SettingsFeatureInterface
import SwiftUI

public struct MainTabView: View {
    let store: StoreOf<MainTabFeature>
    
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
            
            Tab(
                MainTab.profile.title,
                systemImage: MainTab.profile.imageName
            ) {
                NavigationStack {
                    ProfileView(
                        store: store.scope(
                            state: \.profile,
                            action: \.profile
                        )
                    )
                }
            }
            
            Tab(
                MainTab.settings.title,
                systemImage: MainTab.settings.imageName
            ) {
                SettingsView(
                    store: store.scope(
                        state: \.settings,
                        action: \.settings
                    )
                )
            }
        }
        .tint(DesignSystemAsset.Colors.accentColor.swiftUIColor)
    }
}

//#Preview {
//    MainTabView(
//        store: .init(initialState: MainTabFeature.State()) {
//            MainTabFeature.preview()
//        }
//    )
//}
