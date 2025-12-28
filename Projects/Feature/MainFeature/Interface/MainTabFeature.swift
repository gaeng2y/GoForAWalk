//
//  MainTabFeature.swift
//  MainFeatureInterface
//
//  Created by Kyeongmo Yang on 12/25/25.
//  Copyright © 2025 com.gaeng2y. All rights reserved.
//

import ComposableArchitecture
import Foundation
import SwiftUI

@Reducer
public struct MainTabFeature {
    @ObservableState
    public struct State: Equatable {
        public var currentTab: MainTab = .home
        
//        var feed: FeedFeature.State = .init()
//        var profile: ProfileFeature.State = .init()
        
        public init() {}
    }
    
    public enum Action {
        case selectTab(MainTab)
//        case checkTodayAvailability
//        case todayAvailabilityResponse(TodayFootstepAvailability)
//        case showCannotCreateAlert
        
//        case feed(FeedFeature.Action)
//        case profile(ProfileFeature.Action)
//        case alert(PresentationAction<Alert>)
        case delegate(Delegate)
        
        public enum Delegate {
            case userDidLogout
        }
        
//        public enum Alert {
//            case confirmCannotCreate
//        }
    }
    
    let reduce: (inout State, Action) -> Effect<Action>
    
    public init(reduce: @escaping (inout State, Action) -> Effect<Action>) {
        self.reduce = reduce
    }
    
    public var body: some ReducerOf<Self> {
        Reduce(reduce)
//            .ifLet(\.$alert, action: \.alert)
    }
}
