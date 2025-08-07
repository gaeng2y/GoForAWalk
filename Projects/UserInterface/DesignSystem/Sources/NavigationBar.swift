//
//  NavigationBar.swift
//  DesignSystem
//
//  Created by Kyeongmo Yang on 7/1/25.
//  Copyright © 2025 com.gaeng2y. All rights reserved.
//

import SwiftUI

public struct NavigationBar: View {
    let title: String
    let leadingItems: [NavigationHeaderItem]
    let trailingItems: [NavigationHeaderItem]
    
    public init(
        title: String,
        leadingItems: [NavigationHeaderItem] = [],
        trailingItems: [NavigationHeaderItem] = []
    ) {
        self.title = title
        self.leadingItems = leadingItems
        self.trailingItems = trailingItems
    }
    
    public var body: some View {
        HStack(spacing: 16) {
            HStack(spacing: 12) {
                ForEach(leadingItems) { item in
                    Button(action: item.action) {
                        item.content
                    }
                    .buttonStyle(.plain)
                }
            }
            
            Text(title)
                .font(.title)
                .bold()
                .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack(spacing: 12) {
                ForEach(trailingItems) { item in
                    Button(action: item.action) {
                        item.content
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .padding(.horizontal)
        .padding(.top, 10)
        .padding(.bottom, 20)
    }
}

// MARK: - Navigation Header Item
public struct NavigationHeaderItem: Identifiable {
    public let id = UUID()
    let content: AnyView
    let action: () -> Void
    
    public init<Content: View>(
        @ViewBuilder content: () -> Content,
        action: @escaping () -> Void
    ) {
        self.content = AnyView(content())
        self.action = action
    }
}

// MARK: - Convenience Initializers
public extension NavigationHeaderItem {
    // 시스템 아이콘용 초기화
    static func systemImage(
        _ name: String,
        font: Font = .title2,
        color: Color = .blue,
        action: @escaping () -> Void
    ) -> NavigationHeaderItem {
        NavigationHeaderItem(
            content: {
                Image(systemName: name)
                    .font(font)
                    .foregroundStyle(color)
            },
            action: action
        )
    }
    
    // 텍스트 버튼용 초기화
    static func text(
        _ text: String,
        font: Font = .body,
        color: Color = .blue,
        action: @escaping () -> Void
    ) -> NavigationHeaderItem {
        NavigationHeaderItem(
            content: {
                Text(text)
                    .font(font)
                    .foregroundStyle(color)
            },
            action: action
        )
    }
}
