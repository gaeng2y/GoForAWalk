//
//  SettingFeature.swift
//  SettingsFeatureInterface
//
//  Created by Kyeongmo Yang on 12/21/25.
//  Copyright © 2025 com.gaeng2y. All rights reserved.
//

import AuthServiceInterface
import ComposableArchitecture
import Foundation
import UserServiceInterface

@Reducer
public struct SettingsFeature: @unchecked Sendable {
    @ObservableState
    public struct State: Equatable {
        let menus: [SettingsMenu] = SettingsMenu.allCases
        public var isLoading: Bool = false
        @Presents public var alert: AlertState<Action.Alert>?
        
        public init() {}
    }
    
    public enum Action {
        case backButtonTapped
        case settingsMenuTapped(SettingsMenu)
        case showDeleteAlert
        case alert(PresentationAction<Alert>)
        case withdrawUserSuccess
        case delegate(Delegate)
        
        @CasePathable
        public enum Alert {
            case confirmDeleteAccount
        }
        
        public enum Delegate {
            case userDidLogout
        }
    }
    
    let authClient: any AuthClient
    let profileClient: any ProfileClient
    let reduce: (inout State, Action) -> Effect<Action>
    
    public init(
        authClient: any AuthClient,
        profileClient: any ProfileClient,
        reduce: @escaping (inout State, Action) -> Effect<Action>
    ) {
        self.authClient = authClient
        self.profileClient = profileClient
        self.reduce = reduce
    }
    
    public var body: some ReducerOf<Self> {
        Reduce(reduce)
            .ifLet(\.$alert, action: \.alert)
    }
}
