//
//  SettingsView.swift
//  SettingsFeature
//
//  Created by Kyeongmo Yang on 7/6/25.
//  Copyright © 2025 com.gaeng2y. All rights reserved.
//

import ComposableArchitecture
import DesignSystem
import SettingsFeatureInterface
import SwiftUI

public struct SettingsView: View {
    @StateObject private var store: StoreOf<SettingsFeature>
    
    public init(store: StoreOf<SettingsFeature>) {
        _store = .init(wrappedValue: store)
    }
    
    public var body: some View {
        ScrollView {
            NavigationBar(
                title: "설정",
                leadingItems: [
                    .systemImage(
                        "arrow.backward",
                        color: .black
                    ) {
                        
                    }
                ]
            )
            
            List {
                ForEach(
                    SettingsMenu.allCases,
                    id: \.self
                ) { menu in
                    Text(menu.title)
                        .onTapGesture {
                            store.send(.settingsMenuTapped(menu))
                        }
                }
            }
        }
        .alert($store.scope(state: \.alert, action: \.alert))
        .toolbar(.hidden)
    }
}

#Preview {
    SettingsView(
        store: Store(initialState: SettingsFeature.State()) {
            SettingsFeature()
        }
    )
}
