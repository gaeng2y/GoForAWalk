//
//  NetworkError.swift
//  NetworkingInterface
//
//  Created by Kyeongmo Yang on 4/15/25.
//  Copyright © 2025 com.gaeng2y. All rights reserved.
//

import Foundation

public enum NetworkError: Error, Equatable {
    public enum URLRequestError: Error {
        case urlComponentError
        case queryEncodingError
        case bodyEncodingError
        case makeURLError
        
        var message: String {
            switch self {
            case .urlComponentError:
                return "urlComponentError"
            case .queryEncodingError:
                return "queryEncodingError"
            case .bodyEncodingError:
                return "queryEncodingError"
            case .makeURLError:
                return "makeURLError"
            }
        }
    }
    
    public static func == (lhs: NetworkError, rhs: NetworkError) -> Bool {
        lhs.messsage == rhs.messsage
    }
    
    case urlRequestError(URLRequestError)
    case invalidURL
    case failedDecoding
    case failedAuthorization
    case noResponse
    case badRequest
    case lostConnection
    case internalError
    case unknownError
    
    var messsage: String {
        switch self {
        case .urlRequestError(let urlRequestError): urlRequestError.message
        case .invalidURL: "Invalid URL"
        case .failedDecoding: "Decoding failed"
        case .failedAuthorization: "Authorization failed"
        case .noResponse: "No Response"
        case .badRequest: "Bad Request From Client"
        case .lostConnection: "Connection Lost"
        case .internalError: "Internal Error"
        case .unknownError: "This Error is Unknown"
        }
    }
}
