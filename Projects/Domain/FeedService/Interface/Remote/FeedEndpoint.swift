//
//  FeedEndpoint.swift
//  FeedService
//
//  Created by Kyeongmo Yang on 6/9/25.
//  Copyright © 2025 com.gaeng2y. All rights reserved.
//

import Auth
import Foundation
import NetworkingInterface

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
    
    public static func createFootstep(with body: CreateFootstepRequestDTO) -> EndPoint<CreateFootstepResponseDTO> {
        let boundary = "Boundary-\(UUID().uuidString)"
        let headers = [
            "Authorization": "Bearer \(LocalAuthStoreImpl().loadToken().accessToken)",
            "Content-Type": "multipart/form-data; boundary=\(boundary)"
        ]

        let httpBody = createMultipartBody(
            with: body,
            boundary: boundary
        )
        
        return EndPoint(
            path: "footsteps",
            httpMethod: .post,
            bodyParameters: httpBody,
            headers: headers
        )
    }
    
    public static func checkTodayAvailability() -> EndPoint<TodayFootstepAvailabilityResponseDTO> {
        EndPoint(
            path: "footsteps/today/availability",
            httpMethod: .get,
            headers: ["Authorization": "Bearer \(LocalAuthStoreImpl().loadToken().accessToken)"]
        )
    }
    
    private static func createMultipartBody(
        with requestDTO: CreateFootstepRequestDTO,
        boundary: String
    ) -> Data {
        var body = Data()
        
        func appendString(_ string: String) {
            if let data = string.data(using: .utf8) {
                body.append(data)
            }
        }
        
        // --- Part 1: 이미지 데이터 (data) ---
        // cURL의 --form 'data=@"/path/to/image.jpg"' 부분
        appendString("--\(boundary)\r\n")
        // Content-Disposition 헤더에 name과 함께 filename을 명시해야 합니다.
        appendString("Content-Disposition: form-data; name=\"data\"; filename=\"\(requestDTO.fileName)\"\r\n")
        // 해당 파트의 Content-Type을 명시해줍니다.
        appendString("Content-Type: \(requestDTO.mimeType)\r\n\r\n")
        body.append(requestDTO.data)
        appendString("\r\n")
        
        // --- Part 2: 텍스트 데이터 (content) ---
        // cURL의 --form 'content="123"' 부분
        appendString("--\(boundary)\r\n")
        appendString("Content-Disposition: form-data; name=\"content\"\r\n\r\n")
        appendString(requestDTO.content)
        appendString("\r\n")
        
        // --- Body 종료 ---
        appendString("--\(boundary)--\r\n")
        
        return body
    }
}
