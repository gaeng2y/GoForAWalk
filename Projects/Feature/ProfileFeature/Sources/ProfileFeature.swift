//
//  ProfileFeature.swift
//  ProfileFeature
//
//  Created by Kyeongmo Yang on 6/27/25.
//  Copyright © 2025 com.gaeng2y. All rights reserved.
//

import ComposableArchitecture
import Foundation
import SettingsFeature
import UserServiceInterface

@Reducer
public struct ProfileFeature {
    @ObservableState
    public struct State: Equatable {
        var profile: Profile = .init()
        var isShowingNicknameAlert = false
        var nicknameInput = ""
        
        public init() {}
    }
    
    public enum Action: BindableAction {
        case binding(BindingAction<State>)
        case onAppear
        case fetchProfile(Profile)
        case showNicknameChangeAlert
        case confirmNicknameChange
        case cancelNicknameChange
        case nicknameChanged
        case delegate(Delegate)

        public enum Delegate {
            case userDidLogout
        }
    }
    
    private let profileClient: ProfileClient
    
    public init(
        profileClient: ProfileClient
    ) {
        self.profileClient = profileClient
    }
    
    public var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .binding:
                return .none

            case .onAppear:
                return .run { send in
                    let profile = try await profileClient.fetchProfile()
                    await send(.fetchProfile(profile))
                }

            case .fetchProfile(let profile):
                state.profile = profile
                return .none

            case .showNicknameChangeAlert:
                state.nicknameInput = state.profile.nickname
                state.isShowingNicknameAlert = true
                return .none

            case .confirmNicknameChange:
                let nickname = state.nicknameInput.trimmingCharacters(in: .whitespacesAndNewlines)
                guard !nickname.isEmpty, nickname.count <= 8 else {
                    return .none
                }
                state.isShowingNicknameAlert = false
                return .run { send in
                    try await profileClient.changeNickname(nickname)
                    await send(.nicknameChanged)
                }

            case .cancelNicknameChange:
                state.isShowingNicknameAlert = false
                state.nicknameInput = ""
                return .none

            case .nicknameChanged:
                return .run { send in
                    let profile = try await profileClient.fetchProfile()
                    await send(.fetchProfile(profile))
                }

            case .path(.element(id: _, action: .settings(.delegate(.userDidLogout)))):
                return .send(.delegate(.userDidLogout))

            case .path:
                return .none
                
            case .delegate:
                return .none
            }
        }
    }
}
