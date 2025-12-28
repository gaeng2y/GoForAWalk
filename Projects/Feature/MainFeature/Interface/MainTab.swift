//
//  MainTab.swift
//  MainFeature
//
//  Created by Kyeongmo Yang on 5/15/25.
//  Copyright © 2025 com.gaeng2y. All rights reserved.
//

import Foundation

public enum MainTab: Equatable, Hashable, CaseIterable {
    case home
    case record
    case profile
    case settings
    
    var title: String {
        switch self {
        case .home: "홈"
        case .record: "인증"
        case .profile: "프로필"
        case .settings: "설정"
        }
    }
    
    var imageName: String {
        switch self {
        case .home: "house"
        case .record: "camera.circle"
        case .profile: "person.circle"
        case .settings: "gear"
        }
    }
}
