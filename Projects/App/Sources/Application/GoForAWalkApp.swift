//
//  GoForAWalkApp.swift
//  GoForAWalk
//
//  Created by Kyeongmo Yang on 5/6/25.
//  Copyright © 2025 com.gaeng2y. All rights reserved.
//

import KakaoSDKAuth
import KakaoSDKCommon
import KakaoSDKUser
import SwiftUI

@main
struct GoForAWalkApp: App {
    init() {
        KakaoSDK.initSDK(appKey: "967669c3b7e25ab9fa8fda2775b8f581")
    }
    
    var body: some Scene {
        WindowGroup {
            RootView(store: .init(initialState: RootFeature.State()) {
                RootFeature()
            }).onOpenURL { url in
                if AuthApi.isKakaoTalkLoginUrl(url) {
                    _ = AuthController.handleOpenUrl(url: url)
                }
            }
        }
    }
}
