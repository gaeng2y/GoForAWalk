//
//  GoForAWalkApp.swift
//  GoForAWalk
//
//  Created by Kyeongmo Yang on 5/6/25.
//  Copyright © 2025 com.gaeng2y. All rights reserved.
//

import KakaoSDKAuth
import KakaoSDKUser
import SwiftUI

@main
struct GoForAWalkApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            RootView(
                store: .init(initialState: RootFeature.State()) {
                    RootFeature()
                }
            ).onOpenURL { url in
                if AuthApi.isKakaoTalkLoginUrl(url) {
                    _ = AuthController.handleOpenUrl(url: url)
                }
            }
        }
    }
}
