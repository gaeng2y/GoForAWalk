//
//  PostFootstepFeature.swift
//  RecordFeature
//
//  Created by Kyeongmo Yang on 8/3/25.
//  Copyright © 2025 com.gaeng2y. All rights reserved.
//

import ComposableArchitecture
import FeedServiceInterface
import RecordFeatureInterface
import SwiftUI

public extension PostFootstepFeature {
    static func live(feedClient: any FeedClient) -> Self {
        Self { state, action in
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
                guard !state.isLoading else { return .none }
                state.isLoading = true
                return .run { [state] send in
                    let imageData = await ImageRenderer(content: state.resultImage)
                        .uiImage?
                        .jpegData(compressionQuality: 0.4)
                    guard let imageData else {
                        await send(.delegate(.dismiss))
                        return
                    }
                    do {
                        try await feedClient.createFootstep(data: imageData, content: state.todaysMessage, fileName: "image.jpeg")
                        await send(.delegate(.dismiss))
                    } catch {
                        await send(.showErrorAlert(error.localizedDescription))
                    }
                }
                .cancellable(id: "createFootstep")

            case .delegate:
                return .none

            case .showErrorAlert:
                state.isLoading = false
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
    }
}
