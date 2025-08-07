//
//  SignInButton.swift
//  DesignSystem
//
//  Created by Kyeongmo Yang on 7/31/25.
//  Copyright © 2025 com.gaeng2y. All rights reserved.
//

import SwiftUI

public enum SignInProvider: CaseIterable {
    case kakao
    case apple
    
    var symbol: Image {
        switch self {
        case .kakao: Image(asset: DesignSystemAsset.Images.SignIn.kakaoSymbol)
        case .apple: Image(systemName: "apple.logo")
        }
    }
    
    var title: String {
        switch self {
        case .kakao: "카카오 로그인"
        case .apple: "애플 로그인"
        }
    }
    
    var backgroundColor: Color {
        switch self {
        case .kakao: Color(asset: DesignSystemAsset.Colors.kakaoYellow)
        case .apple: .black
        }
    }
    
    var titleColor: Color {
        switch self {
        case .kakao: .black
        case .apple: .white
        }
    }
}

public struct SignInButton: View {
    private let provider: SignInProvider
    private let action: () -> Void
    
    public init(
        provider: SignInProvider,
        action: @escaping () -> Void
    ) {
        self.provider = provider
        self.action = action
    }
    
    public var body: some View {
        Button(action: action) {
            ZStack {
                provider.backgroundColor
                
                Text(provider.title)
                    .foregroundStyle(provider.titleColor)
                
                HStack {
                    provider.symbol
                        .resizable()
                        .scaledToFit()
                        .frame(width: 18, height: 18)
                        .padding(.leading, 14)
                        .foregroundStyle(provider.titleColor)
                    Spacer()
                }
            }
        }
    }
}

#Preview {
    VStack {
        SignInButton(provider: .kakao) {
            print("탭")
        }
        
        SignInButton(provider: .apple) {
            print("탭")
        }
    }
}
