//
//  ProfileFeature.swift
//  ProfileFeature
//
//  Created by Kyeongmo Yang on 6/27/25.
//  Copyright © 2025 com.gaeng2y. All rights reserved.
//

import ComposableArchitecture
import Foundation
import UserServiceInterface

@Reducer
public struct ProfileFeature {
    @ObservableState
    public struct State: Equatable {
        public var profile: Profile = .init()
        public var isLoading = true
        public var isShowingNicknameAlert = false
        public var nicknameInput = ""

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
    }
    
    private let profileClient: ProfileClient
    private let reduce: (inout State, Action) -> Effect<Action>
    
    public init(
        profileClient: ProfileClient,
        reduce: @escaping (inout State, Action) -> Effect<Action>
    ) {
        self.profileClient = profileClient
        self.reduce = reduce
    }
    
    public var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce(reduce)
    }
}
