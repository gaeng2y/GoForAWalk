//
//  PostFootstepFeature.swift
//  RecordFeature
//
//  Created by Kyeongmo Yang on 8/3/25.
//  Copyright © 2025 com.gaeng2y. All rights reserved.
//

import ComposableArchitecture
import FeedService
import FeedServiceInterface
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
            case dismiss
        }
    }
    
    @Dependency(\.feedClient) var feedClient
    
    public func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .cancelButtonTapped:
            return .run { send in
                await send(.delegate(.dismiss))
            }
            
        case .saveButtonTapped:
            return .run { [resultImage = state.resultImage ] send in
                await send(.delegate(.savePhotos(resultImage)))
            }
            
        case let .todaysMessageChanged(message):
            if message.count <= state.maxCharacterCount {
                state.todaysMessage = message
            }
            return .none
            
        case .delegate:
            return .run { [state] send in
                let imageData = await ImageRenderer(content: state.resultImage).uiImage?.jpegData(compressionQuality: 0.4)
                guard let imageData else {
                    return
                }
                let dto = CreateFootstepRequestDTO(data: imageData, content: state.todaysMessage)
                do {
                    try await feedClient.createFootstep(dto)
                    await send(.delegate(.dismiss))
                } catch {
                    print(error.localizedDescription)
                }
            }
            .cancellable(id: "createFootstep")
        }
    }
}
