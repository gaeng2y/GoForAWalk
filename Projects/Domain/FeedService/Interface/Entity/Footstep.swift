//
//  Footstep.swift
//  FeedService
//
//  Created by Kyeongmo Yang on 6/9/25.
//  Copyright © 2025 com.gaeng2y. All rights reserved.
//

import Foundation

public struct Footstep: Identifiable, Equatable, Sendable {
    public static func == (lhs: Footstep, rhs: Footstep) -> Bool {
        lhs.id == rhs.id
    }
    
    public let id: Int
    public let userNickname: String
    public let createdAt: Date
    public let imageUrl: URL?
    public let content: String?
    
    public var presentedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: createdAt)
    }
    
    public init(
        id: Int,
        userNickname: String,
        createdAt: Date,
        imageUrl: URL?,
        content: String?
    ) {
        self.id = id
        self.userNickname = userNickname
        self.createdAt = createdAt
        self.imageUrl = imageUrl
        self.content = content
    }
}

extension Footstep {
    public static let mock: Footstep = .init(
        id: 1,
        userNickname: "닉네임테스트",
        createdAt: .now,
        imageUrl: URL(string: "https://github.com/yavuzceliker/sample-images/blob/main/images/image-114.jpg?raw=true"),
        content: "이 편지는 영국에서 최초로 시작되어 일년에 한바퀴를 돌면서 받는 사람에게 행운을(50글자)"
    )
}
