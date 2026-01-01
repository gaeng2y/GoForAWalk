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
    case history
    case profile
    case menu
    
    var title: String {
        switch self {
        case .home: "홈"
        case .history: "기록"
        case .profile: "프로필"
        case .menu: "전체"
        }
    }
}
