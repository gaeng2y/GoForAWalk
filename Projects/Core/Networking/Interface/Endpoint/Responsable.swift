//
//  Responsable.swift
//  NetworkingInterface
//
//  Created by Kyeongmo Yang on 4/15/25.
//  Copyright © 2025 com.gaeng2y. All rights reserved.
//

import Foundation

public struct EmptyData: Decodable, Equatable { }

public protocol Responsable {
    associatedtype Response
}
