//
//  FeedEmptyView.swift
//  DesignSystem
//
//  Created by Kyeongmo Yang on 1/24/26.
//  Copyright © 2026 com.gaeng2y. All rights reserved.
//

import SwiftUI

public struct FeedEmptyView: View {
    public init() {}
    
    public var body: some View {
        VStack {
            Spacer()
            
            CheckmarkInCircle()
                .padding(.bottom, 23)
            
            Text("아직 발자취가 없어요.")
                .font(.system(size: 22, weight: .bold))
                .padding(.bottom, 13)
            
            Text("첫 발자취를 남겨보세요!\n당신만의 특별한 순간을 공유해주세요.")
                .font(.system(size: 16))
                .multilineTextAlignment(.center)
                .foregroundStyle(Color.gray)
            
            Spacer()
        }
    }
}

fileprivate struct CheckmarkInCircle: View {
    var body: some View {
        ZStack {
            // 갈색 외부 원
            Circle()
                .fill(DesignSystemAsset.Colors.accentColor.swiftUIColor)
                .frame(width: 120, height: 120)
            
            Circle()
                .fill(Color.white)
                .frame(width: 40, height: 40)
            
            // 흰색 내부 원 + 체크마크
            Image(systemName: "checkmark")
                .font(.system(size: 25, weight: .bold))
                .foregroundStyle(DesignSystemAsset.Colors.accentColor.swiftUIColor)
        }
    }
}

#Preview {
    FeedEmptyView()
}
