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
    @Bindable var store: StoreOf<PostFootstepFeature>
    @FocusState private var isTextFieldFocused: Bool

    public var body: some View {
        GeometryReader { geometry in
            ScrollViewReader { scrollProxy in
                ScrollView {
                    LazyVStack(spacing: 0) {
                        // Image Section
                        VStack(spacing: 0) {
                            store.resultImage
                                .resizable()
                                .scaledToFit()
                                .frame(maxWidth: .infinity)
                                .aspectRatio(CameraSetting.ratio, contentMode: .fit)
                                .background(Color.white)
                                .cornerRadius(16)
                                .shadow(color: .black.opacity(0.08), radius: 8, x: 0, y: 4)
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, 20)

                        // Input Section
                        VStack(spacing: 24) {
                            messageInputView
                                .id("textField")

                            buttonsView
                                .id("buttons")
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, 32)
                    }
                    .padding(.bottom, max(geometry.safeAreaInsets.bottom + 34, 100))
                }
                .scrollDismissesKeyboard(.interactively)
                .background(Color(UIColor.systemBackground))
                .contentShape(Rectangle())
                .onTapGesture {
                    if isTextFieldFocused {
                        isTextFieldFocused = false
                    }
                }
                .onChange(of: isTextFieldFocused) { _, isFocused in
                    if isFocused {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            scrollProxy.scrollTo("textField", anchor: .center)
                        }
                    }
                }
            }
        }
        .navigationTitle("발자취")
        .navigationBarTitleDisplayMode(.large)
        .alert($store.scope(state: \.alert, action: \.alert))
    }
    
    private var messageInputView: some View {
        VStack(spacing: 0) {
            TextField(
                "(선택) 오늘의 한 마디를 남겨주세요 :)",
                text: $store.todaysMessage,
                axis: .vertical
            )
            .textFieldStyle(.plain)
            .font(.system(size: 16, weight: .regular))
            .foregroundColor(.primary)
            .lineLimit(2...3)
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .background(Color(UIColor.tertiarySystemFill))
            .cornerRadius(20)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(isTextFieldFocused ? DesignSystemAsset.Colors.accentColor.swiftUIColor : Color.clear, lineWidth: 1.5)
            )
            .focused($isTextFieldFocused)
            .submitLabel(.done)
            .onSubmit {
                isTextFieldFocused = false
            }
            
            // Character count
            HStack {
                Spacer()
                Text("(\(store.todaysMessage.count)/50)")
                    .font(.system(size: 13, weight: .regular))
                    .foregroundColor(.secondary)
            }
            .padding(.top, 8)
            .padding(.horizontal, 4)
        }
    }
    
    private var buttonsView: some View {
        HStack(spacing: 12) {
            Button {
                store.send(.saveButtonTapped)
            } label: {
                if store.isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                } else {
                    Text("남기기 😽")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(.white)
                }
            }
            .frame(height: 50)
            .frame(maxWidth: .infinity)
            .background(
                LinearGradient(
                    colors: [
                        DesignSystemAsset.Colors.accentColor.swiftUIColor,
                        DesignSystemAsset.Colors.accentColor.swiftUIColor.opacity(0.8)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .cornerRadius(25)
            .shadow(color: DesignSystemAsset.Colors.accentColor.swiftUIColor.opacity(0.3), radius: 8, x: 0, y: 4)
            .disabled(store.isLoading)
            
            Button {
                store.send(.cancelButtonTapped)
            } label: {
                Text("취소")
                    .font(.system(size: 17, weight: .medium))
                    .foregroundColor(.primary)
            }
            .frame(width: 80, height: 50)
            .background(Color(UIColor.secondarySystemFill))
            .cornerRadius(25)
        }
    }
}
