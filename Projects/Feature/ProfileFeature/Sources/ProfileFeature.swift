//
//  ProfileFeature.swift
//  ProfileFeature
//
//  Created by Kyeongmo Yang on 6/27/25.
//  Copyright © 2025 com.gaeng2y. All rights reserved.
//

import ComposableArchitecture
import Foundation
import ProfileFeatureInterface
import UserServiceInterface

public extension ProfileFeature {
    static func live(profileClient: ProfileClient) -> Self {
        Self(profileClient: profileClient) { state, action in
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
                state.isLoading = false
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
                state.profile = state.profile.copying(nickname: state.nicknameInput)
                return .none
            }
        }
    }
}
