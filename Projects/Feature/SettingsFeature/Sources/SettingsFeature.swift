//
//  SettingsFeature.swift
//  SettingsFeature
//
//  Created by Kyeongmo Yang on 7/9/25.
//  Copyright © 2025 com.gaeng2y. All rights reserved.
//

import AuthServiceInterface
import ComposableArchitecture
import SettingsFeatureInterface
import UserServiceInterface

public extension SettingsFeature {
    static func live(
        authClient: any AuthClient,
        profileClient: any ProfileClient
    ) -> Self {
        Self(
            authClient: authClient,
            profileClient: profileClient
        ) { state, action in
            @Dependency(\.dismiss) var dismiss
            
            switch action {
            case .backButtonTapped:
                return .run { _ in
                    await dismiss()
                }
                
            case .settingsMenuTapped(let menu):
                switch menu {
                case .withdrawAccount:
                    return .send(.showDeleteAlert)
                }
                
            case .showDeleteAlert:
                state.alert = AlertState(
                    title: {
                        TextState("회원탈퇴")
                    }, actions: {
                        ButtonState(role: .cancel) {
                            TextState("취소")
                        }
                        ButtonState(role: .destructive, action: .confirmDeleteAccount) {
                            TextState("확인")
                        }
                    }, message: {
                        TextState("회원 탈퇴 시 걷기 인증 기록이 모두 사라지고, 되돌릴 수 없어요. 탈퇴를 진행할까요?")
                    }
                )
                return .none
                
            case .alert(.presented(.confirmDeleteAccount)):
                state.isLoading = true
                return .run { [authClient] send in
                    do {
                        try await profileClient.withdrawUser()
                        authClient.deleteAll()
                        await send(.withdrawUserSuccess)
                    } catch {
                        authClient.deleteAll()
                        await send(.withdrawUserSuccess)
                    }
                }
                
            case .withdrawUserSuccess:
                state.isLoading = false
                return .run { send in
                    await send(.delegate(.userDidLogout))
                    await dismiss()
                }
                
            case .alert:
                return .none
                
            case .delegate:
                return .none
            }
        }
    }
}
