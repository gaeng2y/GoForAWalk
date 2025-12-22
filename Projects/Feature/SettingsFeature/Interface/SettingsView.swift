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
    @StateObject private var store: StoreOf<SettingsFeature>
    
    public init(store: StoreOf<SettingsFeature>) {
        _store = .init(wrappedValue: store)
    }
    
    public var body: some View {
        NavigationView {
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
        }
        .navigationTitle("설정")
        .alert($store.scope(state: \.alert, action: \.alert))
    }
}
