//
//  MainTab.swift
//  MainFeature
//
//  Created by Kyeongmo Yang on 5/15/25.
//  Copyright © 2025 com.gaeng2y. All rights reserved.
//

import Foundation
import SwiftUI

public enum MainTab: Hashable, CaseIterable {
    case home
    case record
    case profile
    
    var title: String {
        switch self {
        case .home: "홈"
        case .record: "인증"
        case .profile: "프로필"
        }
    }
    
    var imageName: String {
        switch self {
        case .home: "house"
        case .record: "camera.circle"
        case .profile: "person.circle"
        }
    }
}
