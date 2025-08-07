//
//  PostCreationView.swift
//  RecordFeature
//
//  Created by Kyeongmo Yang on 7/30/25.
//  Copyright © 2025 com.gaeng2y. All rights reserved.
//

import CameraInterface
import ComposableArchitecture
import SwiftUI

public struct PostFootstepView: View {
    typealias CameraResultViewStore = ViewStore<PostFootstepFeature.State, PostFootstepFeature.Action>
        
    let store: StoreOf<PostFootstepFeature>
    
    
    
    public var body: some View {
        WithViewStore(self.store, observe: \.self) { viewStore in
            NavigationStack {
                GeometryReader { geometry in
                    VStack {
                        Spacer()
                        
                        viewStore.resultImage
                            .resizable()
                            .scaledToFit()
                            .frame(
                                width: geometry.size.width,
                                height: geometry.size.width * CameraSetting.ratio)
                            .background(Color.white)
                        
                        Spacer()
                        
                        TextField(
                            "(선택) 오늘의 한 마디를 남겨주세요 :)",
                            text: viewStore.binding(
                                get: \.todaysMessage,
                                send: PostFootstepFeature.Action.todaysMessageChanged
                            )
                        )
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal, 35)
                        
                        buttonsView(viewStore: viewStore)
                            .frame(maxWidth: .infinity)
                            .frame(height: 45)
                            .padding(.horizontal, 45)
                        
                        Spacer()
                    }
                    .background(Color.white)
                    
                }
                .navigationTitle("발자취")
            }
        }
    }
    
    private func buttonsView(viewStore: CameraResultViewStore) -> some View {
        HStack(spacing: 10) {
            Button {
                viewStore.send(.saveButtonTapped)
            } label: {
                Text("남기기 😽")
            }
            .buttonStyle(.borderedProminent)
            
            
            Button {
                viewStore.send(.cancelButtonTapped)
            } label: {
                Text("취소")
            }
            .tint(.gray)
            .buttonStyle(.borderedProminent)
        }
    }
}
