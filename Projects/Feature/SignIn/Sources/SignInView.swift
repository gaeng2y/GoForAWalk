//
//  SignInView.swift
//  SignIn
//
//  Created by Kyeongmo Yang on 5/5/25.
//  Copyright © 2025 com.gaeng2y. All rights reserved.
//

import AuthenticationServices
import ComposableArchitecture
import DesignSystem
import SwiftUI

public struct SignInView: View {
    @StateObject private var store: StoreOf<SignInFeature>
    
    public init(store: StoreOf<SignInFeature>) {
        _store = .init(wrappedValue: store)
    }
    
    public var body: some View {
        ZStack {
            DesignSystemAsset.Colors.launchScreenBackground.swiftUIColor
                .ignoresSafeArea()
            
            VStack {
                Image(asset: DesignSystemAsset.Images.logo)
                    .resizable()
                    .frame(width: 190, height: 190)
                
                Text("'가장 쉬운 걷기의 시작'")
                    .font(.system(size: 16, weight: .regular))
                    .foregroundStyle(.gray)
            }
            
            VStack {
                Spacer()
                
                SignInButton(provider: .kakao) {
                    store.send(.kakaoSignInButtonTapped)
                }
                .frame(height: 54)
                .cornerRadius(10)
                .padding(.horizontal, 35)
                
                SignInButton(provider: .apple) {
                }
                .overlay {
                    SignInWithAppleButton { request in
                        request.requestedScopes = [.email]
                    } onCompletion: { result in
                        switch result {
                        case .success(let authorization):
                            store.send(.signInWithAppleCredential(authorization))
                        case .failure(let error):
                            store.send(.signInWithAppleError(error))
                        }
                    }
                    .blendMode(.overlay)
                }
                .frame(height: 54)
                .cornerRadius(10)
                    .padding(.horizontal, 35)
                
                Spacer().frame(height: 20)
            }
        }
        .alert($store.scope(state: \.alert, action: \.alert))
    }
}
