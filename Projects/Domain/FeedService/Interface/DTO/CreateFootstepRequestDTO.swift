
//
//  CreateFootstepRequestDTO.swift
//  FeedServiceInterface
//
//  Created by Kyeongmo Yang on 7/20/25.
//  Copyright © 2025 com.gaeng2y. All rights reserved.
//

import Foundation

public struct CreateFootstepRequestDTO: Encodable {
    public let data: Data
    public let content: String
    public let fileName: String // 예: "image.jpg"
    public let mimeType: String
    
    public init(
        data: Data,
        content: String,
        fileName: String = "image.jpg",
        mimeType: String = "image/jpeg"
    ) {
        self.data = data
        self.content = content
        self.fileName = fileName
        self.mimeType = mimeType
    }
}
