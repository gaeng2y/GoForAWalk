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
    @ObservableState
    public struct State: Equatable {
        var resultImage: Image
        var todaysMessage: String = ""
        let maxCharacterCount = 50
        @Presents var alert: AlertState<Action.Alert>?
    }
    
    public enum Action: BindableAction, Equatable {
        case binding(BindingAction<State>)
        case cancelButtonTapped
        case saveButtonTapped
        case delegate(Delegate)
        case alert(PresentationAction<Alert>)
        case showErrorAlert(String)
        
        public enum Delegate: Equatable {
            case savePhotos(Image)
            case dismiss
        }
        
        public enum Alert: Equatable {
            case confirmError
        }
    }
    
    @Dependency(\.feedClient) var feedClient
    
    public var body: some Reducer<State, Action> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case .binding(\.todaysMessage):
                if state.todaysMessage.count > state.maxCharacterCount {
                    state.todaysMessage = String(state.todaysMessage.prefix(state.maxCharacterCount))
                }
                return .none
                
            case .binding:
                return .none
                
            case .cancelButtonTapped:
                return .run { send in
                    await send(.delegate(.dismiss))
                }
                
            case .saveButtonTapped:
                return .run { [resultImage = state.resultImage ] send in
                    await send(.delegate(.savePhotos(resultImage)))
                }
                
            case .delegate:
                return .run { [state] send in
                    let imageData = await ImageRenderer(content: state.resultImage)
                        .uiImage?
                        .jpegData(compressionQuality: 0.4)
                    guard let imageData else {
                        return
                    }
                    let dto = CreateFootstepRequestDTO(data: imageData, content: state.todaysMessage)
                    do {
                        try await feedClient.createFootstep(dto)
                        await send(.delegate(.dismiss))
                    } catch {
                        await send(.showErrorAlert(error.localizedDescription))
                    }
                }
                .cancellable(id: "createFootstep")
                
            case .showErrorAlert(let errorMessage):
                state.alert = AlertState {
                    TextState("오류")
                } actions: {
                    ButtonState(role: .cancel) {
                        TextState("확인")
                    }
                } message: {
                    TextState("발자취는 하루에 한 번만 등록 가능해요!")
                }
                return .none
                
            case .alert(.presented(.confirmError)):
                return .none
                
            case .alert:
                return .none
            }
        }
        .ifLet(\.$alert, action: \.alert)
    }
}
