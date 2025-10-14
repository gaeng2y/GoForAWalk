//
//  FeedCell.swift
//  FeedFeature
//
//  Created by Kyeongmo Yang on 5/19/25.
//  Copyright © 2025 com.gaeng2y. All rights reserved.
//

import SwiftUI
import FeedServiceInterface

struct FeedCell: View {
    private let footstep: Footstep
    private let onMenuTapped: (Footstep) -> Void

    public init(footstep: Footstep, onMenuTapped: @escaping (Footstep) -> Void) {
        self.footstep = footstep
        self.onMenuTapped = onMenuTapped
    }
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            // Layer 1: Background card
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(uiColor: .systemBackground))
            
            // Layer 2: Content
            VStack(alignment: .leading, spacing: 0) {
                // Header (nickname + date) with space for Menu
                HStack(alignment: .top, spacing: 12) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(footstep.userNickname)
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(.primary)
                        
                        Text(footstep.presentedDate)
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
                AsyncImage(url: footstep.imageUrl) { phase in
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
                if let content = footstep.content, !content.isEmpty {
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
                            onMenuTapped(footstep)
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

#Preview {
    FeedCell(footstep: .mock) { _ in }
}

fileprivate extension Color {
    static let ff6b6b = Color(red: 1.0, green: 107/255, blue: 107/255)
    static let gray757990 = Color(red: 117/255, green: 121/255, blue: 144/255)
}
