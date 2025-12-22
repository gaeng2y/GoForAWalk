
//
//  CreateFootstepRequestDTO.swift
//  FeedServiceInterface
//
//  Created by Kyeongmo Yang on 7/20/25.
//  Copyright © 2025 com.gaeng2y. All rights reserved.
//

import FeedServiceInterface
import Foundation

struct CreateFootstepRequestDTO: Encodable, Sendable {
    let data: Data
    let content: String
    let fileName: String // 예: "image.jpg"
    
    init(
        data: Data,
        content: String,
        fileName: String = "image.jpg"
    ) {
        self.data = data
        self.content = content
        self.fileName = fileName
    }
}
