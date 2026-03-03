//
//  FeedListView.swift
//  FeedFeature
//
//  Created by Kyeongmo Yang on 5/18/25.
//  Copyright © 2025 com.gaeng2y. All rights reserved.
//

import ComposableArchitecture
import DesignSystem
import SwiftUI

public struct FeedListView: View {
    let store: StoreOf<FeedFeature>

    public init(store: StoreOf<FeedFeature>) {
        self.store = store
    }
    
    public var body: some View {
        Group {
            switch store.viewState {
            case .loading:
                LottieLoadingView()
            case .empty:
                FeedEmptyView()
            case .loaded(let footsteps):
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(footsteps) { footstep in
                            FeedCell(item: footstep) {
                                store.send(.footstepCellMenuTapped(footstep.id))
                            }
                            .padding(.horizontal, 16)
                        }
                    }
                    .padding(.vertical, 8)
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .navigationTitle("홈")
        .onAppear {
            store.send(.onAppear)
        }
        .alert(
            "발자취 삭제",
            isPresented: Binding(
                get: { store.deleteTargetId != nil },
                set: { if !$0 { store.send(.cancelDelete) } }
            )
        ) {
            Button("삭제", role: .destructive) {
                store.send(.deleteConfirmed)
            }
            Button("취소", role: .cancel) {
                store.send(.cancelDelete)
            }
        } message: {
            Text("정말 삭제하시겠습니까?")
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
