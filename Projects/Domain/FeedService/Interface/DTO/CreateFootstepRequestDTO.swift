
//
//  CreateFootstepRequestDTO.swift
//  FeedServiceInterface
//
//  Created by Kyeongmo Yang on 7/20/25.
//  Copyright © 2025 com.gaeng2y. All rights reserved.
//

import Foundation

public struct CreateFootstepRequestDTO: Encodable {
    public let image: Data
    public let content: String
    
    public init(image: Data, content: String) {
        self.image = image
        self.content = content
    }
}
