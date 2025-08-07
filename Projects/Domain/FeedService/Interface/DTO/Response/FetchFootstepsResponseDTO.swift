//
//  FetchFootstepsResponseDTO.swift
//  FeedServiceInterface
//
//  Created by Kyeongmo Yang on 6/9/25.
//  Copyright © 2025 com.gaeng2y. All rights reserved.
//

/*
 "footstepId": 1,
 "userNickname": "abc",
 "content": "이 편지는 영국에서...", (nullable)
 "imageUrl": "htts://google/image1.png",
 "createdAt": "2025-05-10T22:00+09:00"
 */

import Foundation

public struct FetchFootstepsResponseDTO: Decodable {
    public let footsteps: [FootstepsResponseDTO]
}
