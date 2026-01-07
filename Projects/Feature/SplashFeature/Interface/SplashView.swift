//
//  SplashView.swift
//  SplashFeatureInterface
//
//  Created by Kyeongmo Yang on 1/6/26.
//  Copyright © 2026 com.gaeng2y. All rights reserved.
//

import ComposableArchitecture
import DesignSystem
import SwiftUI

public struct SplashView: View {
    let store: StoreOf<SplashFeature>
    
    public init(store: StoreOf<SplashFeature>) {
        self.store = store
    }
    
    public var body: some View {
        ZStack {
            DesignSystemAsset.Colors.launchScreenBackground.swiftUIColor
                .ignoresSafeArea()
            
            VStack(spacing: 10) {
                DesignSystemAsset.Images.logo.swiftUIImage
                    .resizable()
                    .scaledToFit()
                    .frame(width: 190, height: 190)
                
                Text("'가장 쉬운 걷기의 시작'")
                    .font(.system(size: 16))
                    .foregroundStyle(.gray)
            }
        }
    }
}
