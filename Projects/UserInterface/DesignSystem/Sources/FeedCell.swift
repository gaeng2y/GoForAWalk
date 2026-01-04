//
//  FeedCell.swift
//  DesignSystem
//
//  Created by Kyeongmo Yang on 1/3/26.
//  Copyright © 2026 com.gaeng2y. All rights reserved.
//

import SwiftUI

public struct FeedCell<Item: FeedCellDisplayable>: View {
    private let item: Item
    private let onMenuTapped: (() -> Void)?

    public init(
        item: Item,
        onMenuTapped: (() -> Void)? = nil
    ) {
        self.item = item
        self.onMenuTapped = onMenuTapped
    }

    public var body: some View {
        ZStack(alignment: .topTrailing) {
            // Layer 1: Background card
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(uiColor: .systemBackground))

            // Layer 2: Content
            VStack(alignment: .leading, spacing: 0) {
                // Header (nickname + date) with space for Menu
                HStack(alignment: .top, spacing: 12) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(item.userNickname)
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(.primary)

                        Text(item.presentedDate)
                            .font(.system(size: 14))
                            .foregroundStyle(.secondary)
                    }

                    Spacer()

                    // Spacer for Menu button
                    Color.clear.frame(width: 50, height: 1)
                }
                .padding(.horizontal, 16)
                .padding(.top, 16)
                .padding(.bottom, 12)

                // Image
                AsyncImage(url: item.imageUrl) { phase in
                    switch phase {
                    case .empty:
                        ZStack {
                            Color.gray.opacity(0.05)
                            Text("사진")
                                .font(.system(size: 16))
                                .foregroundStyle(.secondary)
                        }
                        .frame(height: 250)
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(height: 250)
                            .clipped()
                    case .failure:
                        ZStack {
                            Color.gray.opacity(0.05)
                            Text("사진")
                                .font(.system(size: 16))
                                .foregroundStyle(.secondary)
                        }
                        .frame(height: 250)
                    @unknown default:
                        EmptyView()
                    }
                }

                // Content text
                if let content = item.content, !content.isEmpty {
                    Text(content)
                        .font(.system(size: 14))
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(16)
                }
            }

            // Layer 3: Menu button (독립적인 최상위 레이어)
            VStack {
                HStack {
                    Spacer()

                    Menu {
                        Button(role: .destructive) {
                            onMenuTapped?()
                        } label: {
                            Label(
                                "삭제하기",
                                systemImage: "trash"
                            )
                        }
                    } label: {
                        Image(systemName: "ellipsis")
                            .font(.system(size: 20))
                            .foregroundStyle(.gray)
                            .frame(width: 44, height: 44)
                            .contentShape(Rectangle())
                    }
                }
                .padding(.top, 12)
                .padding(.trailing, 8)

                Spacer()
            }
        }
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.gray.opacity(0.15), lineWidth: 1)
        )
    }
}
