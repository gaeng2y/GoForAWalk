//
//  MainTabFeature.swift
//  MainFeature
//
//  Created by Kyeongmo Yang on 5/15/25.
//  Copyright © 2025 com.gaeng2y. All rights reserved.
//

import ComposableArchitecture
// import FeedFeature
// import FeedServiceInterface
import MainFeatureInterface
// import ProfileFeature
// import RecordFeature
import SwiftUI

public extension MainTabFeature {
    static func live() -> Self {
        Self(
            reduce: { state, action in
                switch action {
                case .selectTab(let tab):
                    state.currentTab = tab
                    return .none
                    
                case .delegate:
                    return .none
                }
            }
        )
    }
}
                    //        Scope(state: \.feed, action: \.feed) {
                    //            FeedFeature()
                    //        }
            //        Scope(state: \.profile, action: \.profile) {
            //            ProfileFeature()
            //        }
            
            

//            case .checkTodayAvailability:
//                return .run { send in
//                    do {
//                        let availability = try await feedClient.checkTodayAvailability()
//                        await send(.todayAvailabilityResponse(availability))
//                    } catch {
//                        // 에러 발생 시 Alert 표시
//                        await send(.showCannotCreateAlert)
//                    }
//                }
//
//            case .todayAvailabilityResponse(let availability):
//                if availability.canCreateToday {
//                    // 생성 가능 → 카메라 열기
//                    state.currentTab = .record
//                    state.usingCamera = CaptureImageFeature.State()
//                } else {
//                    // 생성 불가 → Alert 표시
//                    return .send(.showCannotCreateAlert)
//                }
//                return .none
//
//            case .showCannotCreateAlert:
//                state.alert = AlertState {
//                    TextState("오늘의 발자취")
//                } actions: {
//                    ButtonState(role: .cancel) {
//                        TextState("확인")
//                    }
//                } message: {
//                    TextState("발자취는 하루에 한 번만 등록 가능해요!")
//                }
//                // 원래 탭으로 복귀
//                state.currentTab = state.previousTab
//                return .none

//            case .alert:
//                return .none
//
//            case let .usingCamera(.presented(.delegate(.savePhoto(image)))):
//                state.image = image
//                return .none
//
//            case .usingCamera(.dismiss):
//                state.usingCamera = nil
//                state.currentTab = state.previousTab
//                return .none
//
//            case .profile(.delegate(.userDidLogout)):
//                return .send(.delegate(.userDidLogout))

//    public var body: some ReducerOf<Self> {
//        .ifLet(\.$alert, action: \.alert)
//        .ifLet(\.$usingCamera, action: \.usingCamera) {
//            CaptureImageFeature()
//        }
//    }
