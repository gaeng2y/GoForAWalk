//
//  SettingsFeature.swift
//  SettingsFeature
//
//  Created by Kyeongmo Yang on 7/9/25.
//  Copyright © 2025 com.gaeng2y. All rights reserved.
//

import ComposableArchitecture
import SettingsFeatureInterface
import UserServiceInterface
import UserService

@Reducer
public struct SettingsFeature {
    @ObservableState
    public struct State: Equatable {
        let menus: [SettingsMenu] = SettingsMenu.allCases
        var isLoading: Bool = false
        @Presents var alert: AlertState<Action.Alert>?
        
        public init() {}
    }
    
    public enum Action {
        case backButtonTapped
        case settingsMenuTapped(SettingsMenu)
        case showDeleteAlert
        case alert(PresentationAction<Alert>)
        case withdrawUserSuccess
        
        @CasePathable
        public enum Alert {
            case confirmDeleteAccount
        }
    }
    
    @Dependency(\.profileClient) var profileClient
    @Dependency(\.dismiss) var dismiss
    
    public init() {}
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .backButtonTapped:
                return .run { send in
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
                return .run { send in
                    try await profileClient.withdrawUser()
                    await send(.withdrawUserSuccess)
                }
                
            case .withdrawUserSuccess:
                state.isLoading = false
                return .none
                
            case .alert:
                return .none
            }
        }
        .ifLet(\.$alert, action: \.alert)
    }
}
