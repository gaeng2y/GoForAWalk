//
//  MainTabFeature.swift
//  MainFeature
//
//  Created by Kyeongmo Yang on 5/15/25.
//  Copyright © 2025 com.gaeng2y. All rights reserved.
//

import ComposableArchitecture
import FeedFeature
import ProfileFeature
import RecordFeature
import SwiftUI

@Reducer
public struct MainTabFeature {
    @ObservableState
    public struct State {
        var currentTab: MainTab = .home
        var previousTab: MainTab = .home

        var feed: FeedFeature.State = .init()
        var profile: ProfileFeature.State = .init()
        @Presents var usingCamera: CaptureImageFeature.State?
        var image: Image?

        public init() {}
    }
    
    public enum Action {
        case selectTab(MainTab)
        
        case feed(FeedFeature.Action)
        case profile(ProfileFeature.Action)
        case usingCamera(PresentationAction<CaptureImageFeature.Action>)
    }
    
    public init() {}
    
    public var body: some ReducerOf<Self> {
        Scope(state: \.feed, action: \.feed) {
            FeedFeature()
        }
        Scope(state: \.profile, action: \.profile) {
            ProfileFeature()
        }
        
        Reduce { state, action in
            switch action {
            case .selectTab(let tab):
                switch tab {
                case .record:
                    state.previousTab = state.currentTab
                    state.currentTab = tab
                    state.usingCamera = CaptureImageFeature.State()
                default:
                    state.currentTab = tab
                }
                return .none
                
            case let .usingCamera(.presented(.delegate(.savePhoto(image)))):
                state.image = image
                return .none
                
            case .usingCamera(.dismiss):
                state.usingCamera = nil
                state.currentTab = state.previousTab
                return .none
                
            default:
                return .none
            }
        }
        .ifLet(\.$usingCamera, action: \.usingCamera) {
            CaptureImageFeature()
        }
    }
}
