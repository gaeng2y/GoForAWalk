//
//  FeedEndpoint.swift
//  FeedService
//
//  Created by Kyeongmo Yang on 6/9/25.
//  Copyright © 2025 com.gaeng2y. All rights reserved.
//

import AuthServiceInterface
import Foundation
import NetworkingInterface

enum FeedEndpoint: Endpoint {
    case fetchFootsteps
    case deleteFootstep(id: Int)
    case createFootstep(dto: CreateFootstepRequestDTO)
    case checkTodayAvailability
    
    var path: String {
        switch self {
        case .fetchFootsteps: "footsteps"
        case .deleteFootstep(let id): "footsteps/\(id)"
        case .createFootstep: "footsteps"
        case .checkTodayAvailability: "footsteps/today/availability"
        }
    }
    
    var method: NetworkingMethod {
        switch self {
        case .fetchFootsteps: .get
        case .deleteFootstep: .delete
        case .createFootstep: .post
        case .checkTodayAvailability: .get
        }
    }
    
    var authRequirement: AuthRequirement { .bearer }
    
    var task: HTTPTask {
        switch self {
        case .fetchFootsteps:
            return .requestPlain
        case .deleteFootstep:
            return .requestPlain
        case .createFootstep(let dto):
            return .uploadMultipart([
                .image(dto.data, name: "data", fileName: dto.fileName),
                .text(dto.content, name: "content")
            ])
        case .checkTodayAvailability:
            return .requestPlain
        }
    }
}
