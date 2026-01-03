//
//  FeedCellDisplayable.swift
//  DesignSystem
//
//  Created by Kyeongmo Yang on 1/3/26.
//  Copyright © 2026 com.gaeng2y. All rights reserved.
//

import Foundation

public protocol FeedCellDisplayable {
    var userNickname: String { get }
    var presentedDate: String { get }
    var imageUrl: URL? { get }
    var content: String? { get }
}
