//
//  SettingsMenu.swift
//  SettingsFeature
//
//  Created by Kyeongmo Yang on 7/6/25.
//  Copyright © 2025 com.gaeng2y. All rights reserved.
//

import Foundation

public enum SettingsMenu: CaseIterable {
    case withdrawAccount
    
    public var title: String {
        switch self {
        case .withdrawAccount:
            return "회원탈퇴"
        }
    }
    
    public func action(_ showingDeleteAlert: inout Bool) {
        switch self {
        case .withdrawAccount:
            showingDeleteAlert = true
        }
    }
}
