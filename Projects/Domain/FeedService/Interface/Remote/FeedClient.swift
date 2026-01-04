//
//  FeedClient.swift
//  FeedServiceInterface
//
//  Created by Kyeongmo Yang on 6/10/25.
//  Copyright © 2025 com.gaeng2y. All rights reserved.
//

import Foundation

public protocol FeedClient: Sendable {
    func fetchFootsteps() async throws -> [Footstep]
    func createFootstep(data: Data, content: String, fileName: String) async throws
    func deleteFootstep(id: Int) async throws
    func checkTodayAvailability() async throws -> TodayFootstepAvailability
    func fetchCalendarFootsteps(startDate: String, endDate: String) async throws -> [Footstep]
}
