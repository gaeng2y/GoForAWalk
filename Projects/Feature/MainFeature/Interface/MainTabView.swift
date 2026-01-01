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
import RecordFeatureInterface
import SettingsFeatureInterface
import SwiftUI

public struct MainTabView: View {
    @Bindable var store: StoreOf<MainTabFeature>

    public init(store: StoreOf<MainTabFeature>) {
        self.store = store
    }

    public var body: some View {
        ZStack(alignment: .bottomTrailing) {
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
                    NavigationStack {
                        SettingsView(
                            store: store.scope(
                                state: \.settings,
                                action: \.settings
                            )
                        )
                    }
                }
            }
            .tint(DesignSystemAsset.Colors.accentColor.swiftUIColor)

            // Floating Action Button
            Button {
                store.send(.floatingButtonTapped)
            } label: {
                Image(systemName: "plus")
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundStyle(.white)
                    .frame(width: 56, height: 56)
                    .background(DesignSystemAsset.Colors.accentColor.swiftUIColor)
                    .clipShape(Circle())
                    .shadow(color: .black.opacity(0.3), radius: 4, x: 0, y: 2)
            }
            .padding(.trailing, 20)
            .padding(.bottom, 100)
        }
        .fullScreenCover(
            store: store.scope(
                state: \.$captureImage,
                action: \.captureImage
            )
        ) { captureImageStore in
            CaptureImageView(store: captureImageStore)
        }
        .alert(
            "오늘은 이미 발자취를 남겼어요",
            isPresented: Binding(
                get: { store.showUnavailableAlert },
                set: { _ in store.send(.dismissUnavailableAlert) }
            )
        ) {
            Button("확인") {
                store.send(.dismissUnavailableAlert)
            }
        } message: {
            Text("발자취는 하루에 한 번만 남길 수 있어요.")
        }
    }
}

//#Preview {
//    MainTabView(
//        store: .init(initialState: MainTabFeature.State()) {
//            MainTabFeature.preview()
//        }
//    )
//}
