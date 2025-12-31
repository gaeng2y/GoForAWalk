//
//  FeedListView.swift
//  FeedFeature
//
//  Created by Kyeongmo Yang on 5/18/25.
//  Copyright © 2025 com.gaeng2y. All rights reserved.
//

import ComposableArchitecture
import DesignSystem
import RecordFeatureInterface
import SwiftUI

public struct FeedListView: View {
    @Bindable var store: StoreOf<FeedFeature>
    
    public init(store: StoreOf<FeedFeature>) {
        self.store = store
    }
    
    public var body: some View {
        ZStack(alignment: .bottomTrailing) {
            ScrollView {
                if store.footsteps.isEmpty {
                    Text("아직 발자취가 없어요.\n첫 발자취를 남겨볼까요?")
                        .multilineTextAlignment(.center)
                        .padding(.top, 40)
                } else {
                    LazyVStack(spacing: 12) {
                        ForEach(store.footsteps) { footsteps in
                            FeedCell(footstep: footsteps) { footstep in
                                store.send(.footstepCellMenuTapped(footstep.id))
                            }
                            .padding(.horizontal, 16)
                        }
                    }
                    .padding(.vertical, 8)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            // Floating Action Button
            Button {
                store.send(.floatingButtonTapped)
            } label: {
                Image(systemName: "plus")
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundStyle(.white)
                    .frame(width: 56, height: 56)
                    .background(DesignSystemAsset.Colors.accentColor.swiftUIColor)
                    .clipShape(Circle())
                    .shadow(color: .black.opacity(0.3), radius: 4, x: 0, y: 2)
            }
            .padding(.trailing, 20)
            .padding(.bottom, 20)
        }
        .navigationTitle("홈")
        .onAppear {
            store.send(.onAppear)
        }
        .fullScreenCover(
            store: store.scope(
                state: \.$captureImage,
                action: \.captureImage
            )
        ) { captureImageStore in
            CaptureImageView(store: captureImageStore)
        }
        .alert(
            "오늘은 이미 발자취를 남겼어요",
            isPresented: Binding(
                get: { store.showUnavailableAlert },
                set: { _ in store.send(.dismissUnavailableAlert) }
            )
        ) {
            Button("확인") {
                store.send(.dismissUnavailableAlert)
            }
        } message: {
            Text("발자취는 하루에 한 번만 남길 수 있어요.")
        }
    }
}

#Preview {
    FeedListView(
        store: .init(initialState: FeedFeature.State()) {
            FeedFeature.preview()
        }
    )
}
