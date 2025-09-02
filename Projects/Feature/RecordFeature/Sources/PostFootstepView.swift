//
//  PostCreationView.swift
//  RecordFeature
//
//  Created by Kyeongmo Yang on 7/30/25.
//  Copyright © 2025 com.gaeng2y. All rights reserved.
//

import CameraInterface
import ComposableArchitecture
import DesignSystem
import SwiftUI

public struct PostFootstepView: View {
    typealias CameraResultViewStore = ViewStore<PostFootstepFeature.State, PostFootstepFeature.Action>
        
    @Bindable var store: StoreOf<PostFootstepFeature>
    
    public var body: some View {
        NavigationStack {
            GeometryReader { proxy in
                VStack {
                    Spacer()
                    
                    store.resultImage
                        .resizable()
                        .scaledToFit()
                        .frame(
                            width: proxy.size.width,
                            height: proxy.size.width * CameraSetting.ratio)
                        .background(Color.white)
                    
                    Spacer()
                    
                    TextField(
                         "(선택) 오늘의 한 마디를 남겨주세요 :)",
                         text: $store.todaysMessage
                     )
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal, 35)
                    
                    buttonsView
                        .frame(height: 100)
                        .padding(.horizontal, 45)
                    
                    Spacer()
                }
                .background(Color.white)
            }
            .navigationTitle("발자취")
            .alert($store.scope(state: \.alert, action: \.alert))
        }
    }
    
    private var buttonsView: some View {
        HStack(spacing: 10) {
            Button {
                store.send(.saveButtonTapped)
            } label: {
                Text("남기기 😽")
            }
            .tint(DesignSystemAsset.Colors.accentColor.swiftUIColor)
            .buttonStyle(.borderedProminent)
            
            
            Button {
                store.send(.cancelButtonTapped)
            } label: {
                Text("취소")
            }
            .tint(.gray)
            .buttonStyle(.borderedProminent)
        }
    }
}
