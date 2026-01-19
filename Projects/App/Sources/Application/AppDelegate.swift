//
//  AppDelegate.swift
//  GoForAWalk
//
//  Created by Kyeongmo Yang on 1/18/26.
//  Copyright © 2026 com.gaeng2y. All rights reserved.
//

import FirebaseCore
import KakaoSDKCommon
import UIKit

final class AppDelegate: NSObject, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        FirebaseApp.configure()
        KakaoSDK.initSDK(appKey: "967669c3b7e25ab9fa8fda2775b8f581")
        return true
    }
}
