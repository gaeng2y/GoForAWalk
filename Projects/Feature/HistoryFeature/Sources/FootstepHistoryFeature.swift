//
//  HistoryFeature.swift
//  HistoryFeature
//
//  Created by Kyeongmo Yang on 1/3/26.
//  Copyright © 2026 com.gaeng2y. All rights reserved.
//

import FeedServiceInterface
import Foundation
import HistoryFeatureInterface

public extension FootstepHistoryFeature {
    static func live(
        feedClient: any FeedClient
    ) -> Self {
        Self { state, action in
            switch action {
            case .onAppear:
                state.isLoading = true
                let currentMonth = state.currentMonth
                return .run { send in
                    let (startDate, endDate) = monthDateRange(for: currentMonth)
                    do {
                        let footsteps = try await feedClient.fetchCalendarFootsteps(
                            startDate: startDate,
                            endDate: endDate
                        )
                        await send(.fetchCalendarFootstepsResponse(footsteps))
                    } catch {
                        await send(.fetchError(error.localizedDescription))
                    }
                }

            case .selectDate(let date):
                state.selectedDate = date
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd"
                let dateString = formatter.string(from: date)
                state.selectedFootstep = state.footsteps.first { $0.date == dateString }
                return .none

            case .changeMonth(let date):
                state.currentMonth = date
                state.selectedDate = nil
                state.selectedFootstep = nil
                state.isLoading = true
                return .run { send in
                    let (startDate, endDate) = monthDateRange(for: date)
                    do {
                        let footsteps = try await feedClient.fetchCalendarFootsteps(
                            startDate: startDate,
                            endDate: endDate
                        )
                        await send(.fetchCalendarFootstepsResponse(footsteps))
                    } catch {
                        await send(.fetchError(error.localizedDescription))
                    }
                }

            case .binding:
                return .none

            case .fetchCalendarFootstepsResponse(let footsteps):
                state.footsteps = footsteps
                state.isLoading = false
                return .none

            case .fetchError(let message):
                state.isLoading = false
                print("HistoryFeature Error: \(message)")
                return .none
            }
        }
    }
}

// MARK: - Helpers

private func monthDateRange(for date: Date) -> (startDate: String, endDate: String) {
    let calendar = Calendar.current
    let components = calendar.dateComponents([.year, .month], from: date)

    guard let startOfMonth = calendar.date(from: components),
          let endOfMonth = calendar.date(byAdding: DateComponents(month: 1, day: -1), to: startOfMonth)
    else {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let today = formatter.string(from: date)
        return (today, today)
    }

    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"

    return (formatter.string(from: startOfMonth), formatter.string(from: endOfMonth))
}
