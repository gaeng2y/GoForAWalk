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
        ScrollView {
            if store.footsteps.isEmpty {
                Text("아직 발자취가 없어요.\n첫 발자취를 남겨볼까요?")
                    .multilineTextAlignment(.center)
                    .padding(.top, 40)
            } else {
                LazyVStack(spacing: 12) {
                    ForEach(store.footsteps) { footstep in
                        FeedCell(footstep: footstep) { footstep in
                            store.send(.footstepCellMenuTapped(footstep.id))
                        }
                        .padding(.horizontal, 16)
                    }
                }
                .padding(.vertical, 8)
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
