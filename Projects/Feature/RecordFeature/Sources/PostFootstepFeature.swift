//
//  PostFootstepFeature.swift
//  RecordFeature
//
//  Created by Kyeongmo Yang on 8/3/25.
//  Copyright © 2025 com.gaeng2y. All rights reserved.
//

import ComposableArchitecture
import SwiftUI

@Reducer
public struct PostFootstepFeature {
    public struct State: Equatable {
        var resultImage: Image
        var todaysMessage: String = ""
        let maxCharacterCount = 50
    }
    
    public enum Action: Equatable {
        case cancelButtonTapped
        case saveButtonTapped
        case todaysMessageChanged(String)
        case delegate(Delegate)
        
        public enum Delegate: Equatable {
            case savePhotos(Image)
        }
    }
    
    @Dependency(\.dismiss) var dismiss
    
    public func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .cancelButtonTapped:
            return .run { _ in await self.dismiss() }
            
        case .saveButtonTapped:
            return .run { [resultImage = state.resultImage ] send in
                await send(.delegate(.savePhotos(resultImage)))
                await self.dismiss()
            }
            
        case let .todaysMessageChanged(message):
            if message.count <= state.maxCharacterCount {
                state.todaysMessage = message
            }
            return .none
            
        case .delegate:
            return .none
        }
    }
}
