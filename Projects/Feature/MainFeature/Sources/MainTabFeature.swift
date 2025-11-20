//
//  MainTabFeature.swift
//  MainFeature
//
//  Created by Kyeongmo Yang on 5/15/25.
//  Copyright © 2025 com.gaeng2y. All rights reserved.
//

import ComposableArchitecture
import FeedFeature
import FeedService
import FeedServiceInterface
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
        @Presents var alert: AlertState<Action.Alert>?
        var image: Image?

        public init() {}
    }
    
    public enum Action {
        case selectTab(MainTab)
        case checkTodayAvailability
        case todayAvailabilityResponse(TodayFootstepAvailability)
        case showCannotCreateAlert

        case feed(FeedFeature.Action)
        case profile(ProfileFeature.Action)
        case usingCamera(PresentationAction<CaptureImageFeature.Action>)
        case alert(PresentationAction<Alert>)
        case delegate(Delegate)

        public enum Delegate {
            case userDidLogout
        }

        public enum Alert {
            case confirmCannotCreate
        }
    }
    
    @Dependency(\.feedClient) var feedClient

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
                    // 탭 변경 전에 API 호출
                    return .send(.checkTodayAvailability)
                default:
                    state.currentTab = tab
                }
                return .none

            case .checkTodayAvailability:
                return .run { send in
                    do {
                        let availability = try await feedClient.checkTodayAvailability()
                        await send(.todayAvailabilityResponse(availability))
                    } catch {
                        // 에러 발생 시 Alert 표시
                        await send(.showCannotCreateAlert)
                    }
                }

            case .todayAvailabilityResponse(let availability):
                if availability.canCreateToday {
                    // 생성 가능 → 카메라 열기
                    state.currentTab = .record
                    state.usingCamera = CaptureImageFeature.State()
                } else {
                    // 생성 불가 → Alert 표시
                    return .send(.showCannotCreateAlert)
                }
                return .none

            case .showCannotCreateAlert:
                state.alert = AlertState {
                    TextState("오늘의 발자취")
                } actions: {
                    ButtonState(role: .cancel) {
                        TextState("확인")
                    }
                } message: {
                    TextState("발자취는 하루에 한 번만 등록 가능해요!")
                }
                // 원래 탭으로 복귀
                state.currentTab = state.previousTab
                return .none

            case .alert:
                return .none

            case let .usingCamera(.presented(.delegate(.savePhoto(image)))):
                state.image = image
                return .none

            case .usingCamera(.dismiss):
                state.usingCamera = nil
                state.currentTab = state.previousTab
                return .none

            case .profile(.delegate(.userDidLogout)):
                return .send(.delegate(.userDidLogout))

            case .delegate:
                return .none

            default:
                return .none
            }
        }
        .ifLet(\.$alert, action: \.alert)
        .ifLet(\.$usingCamera, action: \.usingCamera) {
            CaptureImageFeature()
        }
    }
}
