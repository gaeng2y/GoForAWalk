//
//  SettingsView.swift
//  SettingsFeature
//
//  Created by Kyeongmo Yang on 7/6/25.
//  Copyright © 2025 com.gaeng2y. All rights reserved.
//

import ComposableArchitecture
import DesignSystem
import SwiftUI

public struct SettingsView: View {
    @Bindable private var store: StoreOf<SettingsFeature>
    
    public init(store: StoreOf<SettingsFeature>) {
        self.store = store
    }
    
    public var body: some View {
        List {
            ForEach(
                SettingsMenu.allCases,
                id: \.self
            ) { menu in
                Label(
                    menu.title,
                    systemImage: menu.imageName
                )
                .onTapGesture {
                    store.send(.settingsMenuTapped(menu))
                }
            }
        }
        .navigationTitle("설정")
        .alert($store.scope(state: \.alert, action: \.alert))
    }
}
