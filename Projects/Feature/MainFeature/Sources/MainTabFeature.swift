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
import SwiftUICore

@Reducer
public struct MainTabFeature {
    @ObservableState
    public struct State {
        var currentTab: MainTab = .home
        
        var feed: FeedFeature.State = .init()
        var profile: ProfileFeature.State = .init()
        @Presents var usingCamera: CaptureImageFeature.State?
        var image: Image?
        var disableDismissAnimation: Bool = false
        
        public init() {}
    }
    
    public enum Action {
        case selectTab(MainTab)
        case presentCaptureImage
        
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
                state.currentTab = tab
                return .none
                
            case .feed(let feedAction):
                return .none
                
            case .profile(let profileAction):
                return .none
                
            case .presentCaptureImage:
                state.disableDismissAnimation = false
                state.usingCamera = CaptureImageFeature.State()
                return .none
                
            case let .usingCamera(.presented(.delegate(.savePhoto(image)))):
                state.disableDismissAnimation = true
                state.image = image
                return .none
                
            case .usingCamera:
                return .none
            }
        }
        .ifLet(\.$usingCamera, action: \.usingCamera) {
            CaptureImageFeature()
        }
    }
}
