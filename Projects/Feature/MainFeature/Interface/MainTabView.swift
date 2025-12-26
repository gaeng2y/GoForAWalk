//
//  MainTabView.swift
//  MainFeature
//
//  Created by Kyeongmo Yang on 5/14/25.
//  Copyright © 2025 com.gaeng2y. All rights reserved.
//

import ComposableArchitecture
import DesignSystem
// import FeedFeature
// import ProfileFeature
import SwiftUI

public struct MainTabView: View {
    @Bindable var store: StoreOf<MainTabFeature>
    
    public init(store: StoreOf<MainTabFeature>) {
        self.store = store
    }
    
    public var body: some View {
        TabView(selection: $store.currentTab.sending(\.selectTab)) {
            EmptyView()
        }
        .tint(DesignSystemAsset.Colors.accentColor.swiftUIColor)
    }
}
//            Tab(
//                MainTab.home.title,
//                systemImage: MainTab.home.imageName,
//                value: MainTab.home
//            ) {
//                NavigationStack {
//                    FeedListView(
//                        store: store.scope(
//                            state: \.feed,
//                            action: \.feed
//                        )
//                    )
//                }
//            }
//            
//            Tab(MainTab.record.title, systemImage: MainTab.record.imageName, value: MainTab.record) {
//                Text("등록")
//            }
//            
//            Tab(
//                MainTab.profile.title,
//                systemImage: MainTab.profile.imageName,
//                value: MainTab.profile
//            ) {
//                ProfileView(
//                    store: store.scope(
//                        state: \.profile,
//                        action: \.profile
//                    )
//                )
//            }
//            
//            Tab(
//                MainTab.settings.title,
//                systemImage: MainTab.settings.imageName,
//                value: MainTab.settings
//            ) {
//                SettingsView(store: )
//            }
//        }
//        .fullScreenCover(
//            store: self.store.scope(
//                state: \.$usingCamera,
//                action: \.usingCamera
//            )
//        ) { store in
//            NavigationStack {
//                CaptureImageView(store: store)
//            }
//        }
//        .alert(
//            store: self.store.scope(
//                state: \.$alert,
//                action: \.alert
//            )
//        )

//#Preview {
//    MainTabView(store: Store(initialState: MainTabFeature.State()) {
//        MainTabFeature()
//    })
//}
