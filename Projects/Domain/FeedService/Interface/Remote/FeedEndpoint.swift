//
//  FeedEndpoint.swift
//  FeedService
//
//  Created by Kyeongmo Yang on 6/9/25.
//  Copyright © 2025 com.gaeng2y. All rights reserved.
//

import Auth
import Foundation
import NetworkInterface

public struct FeedEndpoint {
    public static func fetchFootsteps() -> EndPoint<FetchFootstepsResponseDTO> {
        EndPoint(
            path: "footsteps",
            httpMethod: .get,
            headers: ["Authorization": "Bearer \(LocalAuthStoreImpl().loadToken().accessToken)"]
        )
    }
    
    public static func deleteFoorstep(with id: Int) -> EndPoint<EmptyData> {
        EndPoint(
            path: "footsteps/\(id)",
            httpMethod: .delete,
            headers: ["Authorization": "Bearer \(LocalAuthStoreImpl().loadToken().accessToken)"]
        )
    }
    
    public static func createFootstep(with body: CreateFootstepRequestDTO) -> EndPoint<FootstepsResponseDTO> {
        let boundary = "Boundary-\(UUID().uuidString)"
        let headers = [
            "Content-Type": "multipart/form-data; boundary=\(boundary)",
            "Authorization": "Bearer \(LocalAuthStoreImpl().loadToken().accessToken)"
        ]
        
        let httpBody = createBody(with: body, boundary: boundary)
        
        return EndPoint(
            path: "footsteps",
            httpMethod: .post,
            bodyParameters: httpBody,
            headers: headers
        )
    }
    
    private static func createBody(with body: CreateFootstepRequestDTO, boundary: String) -> Data {
        var httpBody = Data()
        
        httpBody.append(Data("--\(boundary)\r\n".utf8))
        httpBody.append(Data("Content-Disposition: form-data; name=\"data\"; filename=\"image.jpg\"\r\n".utf8))
        httpBody.append(Data("Content-Type: image/jpeg\r\n\r\n".utf8))
        httpBody.append(body.image)
        httpBody.append(Data("\r\n".utf8))
        
        httpBody.append(Data("--\(boundary)\r\n".utf8))
        httpBody.append(Data("Content-Disposition: form-data; name=\"content\"\r\n\r\n".utf8))
        httpBody.append(Data(body.content.utf8))
        httpBody.append(Data("\r\n".utf8))
        
        httpBody.append(Data("--\(boundary)--\r\n".utf8))
        
        return httpBody
    }
}
