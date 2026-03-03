//
//  LottieLoadingView.swift
//  DesignSystem
//
//  Created by Codex on 3/3/26.
//

import Lottie
import SwiftUI

public struct LottieLoadingView: View {
    private let animationName: String
    private let size: CGFloat
    
    public init(
        animationName: String = "loading_bear",
        size: CGFloat = 180
    ) {
        self.animationName = animationName
        self.size = size
    }
    
    public var body: some View {
        LottieView(
            animation: LottieAnimation.named(
                animationName,
                bundle: .designSystemResource
            )
        )
        .resizable()
        .playing(loopMode: .loop)
        .configure(\.contentMode, to: .scaleAspectFit)
        .backgroundBehavior(.pauseAndRestore)
        .frame(width: size, height: size)
        .accessibilityLabel("로딩 중")
    }
}

private final class _DesignSystemBundleToken {}

private extension Bundle {
    static var designSystemResource: Bundle {
#if SWIFT_PACKAGE
        return .module
#else
        let baseBundle = Bundle(for: _DesignSystemBundleToken.self)
        let candidateNames = [
            "DesignSystem_DesignSystem",
            "DesignSystem"
        ]
        
        for name in candidateNames {
            if let bundleURL = baseBundle.url(forResource: name, withExtension: "bundle"),
               let bundle = Bundle(url: bundleURL) {
                return bundle
            }
        }
        
        return baseBundle
#endif
    }
}
