//
//  FootstepHistoryView.swift
//  HistoryFeatureInterface
//
//  Created by Kyeongmo Yang on 1/3/26.
//  Copyright © 2026 com.gaeng2y. All rights reserved.
//

import ComposableArchitecture
import DesignSystem
import SwiftUI

public struct FootstepHistoryView: View {
    @Bindable var store: StoreOf<FootstepHistoryFeature>
    
    @State private var selectedYear: Int = Calendar.current.component(.year, from: .now)
    @State private var selectedMonth: Int = Calendar.current.component(.month, from: .now)
    
    private let calendar = Calendar.current
    private let weekdays = ["일", "월", "화", "수", "목", "금", "토"]
    private var years: [Int] {
        let currentYear = calendar.component(.year, from: .now)
        return Array((currentYear - 5)...(currentYear + 5))
    }
    private let months = Array(1...12)
    
    public init(store: StoreOf<FootstepHistoryFeature>) {
        self.store = store
    }
    
    public var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                calendarHeader
                weekdayHeader
                calendarGrid
                
                // 선택된 발자취 표시
                if let footstep = store.selectedFootstep {
                    FeedCell(item: footstep) {
                        store.send(.deleteMenuTapped(footstep.id))
                    }
                    .padding(.top, 24)
                }
                
                Spacer()
            }
            .padding(.horizontal, 16)
        }
        .background(Color(.systemBackground))
        .navigationTitle("기록")
        .onAppear {
            store.send(.onAppear)
        }
        .alert(
            "발자취 삭제",
            isPresented: Binding(
                get: { store.deleteTargetId != nil },
                set: { if !$0 { store.send(.cancelDelete) } }
            )
        ) {
            Button("삭제", role: .destructive) {
                store.send(.deleteConfirmed)
            }
            Button("취소", role: .cancel) {
                store.send(.cancelDelete)
            }
        } message: {
            Text("정말 삭제하시겠습니까?")
        }
    }
    
    // MARK: - Calendar Header
    
    private var calendarHeader: some View {
        HStack {
            Button {
                store.showDatePicker = true
            } label: {
                HStack(spacing: 4) {
                    Text(monthYearString)
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Image(systemName: "chevron.down")
                        .font(.caption)
                }
            }
            .foregroundStyle(.black)
            .sheet(isPresented: $store.showDatePicker) {
                monthYearPicker
            }
            
            Spacer()
        }
        .padding(.vertical, 16)
    }
    
    // MARK: - Month Year Picker
    
    private var monthYearPicker: some View {
        MonthYearPickerView(
            selectedYear: $selectedYear,
            selectedMonth: $selectedMonth,
            years: years,
            months: months,
            currentMonth: store.currentMonth,
            onConfirm: applySelectedMonth
        )
    }
    
    private func applySelectedMonth() {
        var components = DateComponents()
        components.year = selectedYear
        components.month = selectedMonth
        components.day = 1
        if let date = calendar.date(from: components) {
            store.send(.changeMonth(date))
        }
    }
    
    // MARK: - Weekday Header
    
    private var weekdayHeader: some View {
        HStack(spacing: 0) {
            ForEach(weekdays, id: \.self) { day in
                Text(day)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity)
            }
        }
        .padding(.bottom, 8)
    }
    
    // MARK: - Calendar Grid
    
    private var calendarGrid: some View {
        let days = generateDaysInMonth()
        
        return LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 8) {
            ForEach(days, id: \.self) { date in
                CalendarDayCell(
                    date: date,
                    currentMonth: store.currentMonth,
                    selectedDate: store.selectedDate,
                    hasFootstep: hasFootstep(on: date),
                    isToday: calendar.isDateInToday(date)
                ) {
                    store.send(.selectDate(date))
                }
            }
        }
    }
    
    // MARK: - Helpers
    
    private var monthYearString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM"
        return formatter.string(from: store.currentMonth)
    }
    
    private func generateDaysInMonth() -> [Date] {
        guard let monthInterval = calendar.dateInterval(of: .month, for: store.currentMonth),
              let monthFirstWeek = calendar.dateInterval(of: .weekOfMonth, for: monthInterval.start),
              let monthLastWeek = calendar.dateInterval(of: .weekOfMonth, for: monthInterval.end - 1)
        else {
            return []
        }
        
        let startDate = monthFirstWeek.start
        let endDate = monthLastWeek.end
        
        var dates: [Date] = []
        var current = startDate
        
        while current < endDate {
            dates.append(current)
            current = calendar.date(byAdding: .day, value: 1, to: current) ?? current
        }
        
        return dates
    }
    
    private func hasFootstep(on date: Date) -> Bool {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return store.footstepDates.contains(formatter.string(from: date))
    }
}

// MARK: - Calendar Day Cell

private struct CalendarDayCell: View {
    let date: Date
    let currentMonth: Date
    let selectedDate: Date?
    let hasFootstep: Bool
    let isToday: Bool
    let onTap: () -> Void
    
    private let calendar = Calendar.current
    
    private var isCurrentMonth: Bool {
        calendar.isDate(date, equalTo: currentMonth, toGranularity: .month)
    }
    
    private var isSelected: Bool {
        guard let selectedDate else { return false }
        return calendar.isDate(date, inSameDayAs: selectedDate)
    }
    
    private var dayNumber: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter.string(from: date)
    }
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 4) {
                Text(dayNumber)
                    .font(.body)
                    .fontWeight(isToday ? .bold : .regular)
                    .foregroundStyle(textColor)
                
                if hasFootstep && isCurrentMonth {
                    Text("🐻")
                } else {
                    Color.clear
                        .frame(width: 16, height: 16)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .background(backgroundColor)
            .clipShape(RoundedRectangle(cornerRadius: 8))
        }
        .buttonStyle(.plain)
    }
    
    private var textColor: Color {
        if !isCurrentMonth {
            return .secondary.opacity(0.5)
        }
        return .primary
    }
    
    private var backgroundColor: Color {
        if isSelected && isCurrentMonth {
            return DesignSystemAsset.Colors.accentColor.swiftUIColor.opacity(0.4)
        }
        return .clear
    }
}

// MARK: - Month Year Picker View

private struct MonthYearPickerView: View {
    @Environment(\.dismiss) private var dismiss
    
    @Binding var selectedYear: Int
    @Binding var selectedMonth: Int
    let years: [Int]
    let months: [Int]
    let currentMonth: Date
    let onConfirm: () -> Void
    
    private let calendar = Calendar.current
    
    var body: some View {
        NavigationStack {
            HStack(spacing: 0) {
                Picker("년", selection: $selectedYear) {
                    ForEach(years, id: \.self) { year in
                        Text("\(year)년").tag(year)
                    }
                }
                .pickerStyle(.wheel)
                
                Picker("월", selection: $selectedMonth) {
                    ForEach(months, id: \.self) { month in
                        Text("\(month)월").tag(month)
                    }
                }
                .pickerStyle(.wheel)
            }
            .padding()
            .navigationTitle("월 선택")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("완료") {
                        onConfirm()
                        dismiss()
                    }
                }
            }
        }
        .presentationDetents([.medium])
        .onAppear {
            selectedYear = calendar.component(.year, from: currentMonth)
            selectedMonth = calendar.component(.month, from: currentMonth)
        }
    }
}

#Preview {
    FootstepHistoryView(
        store: .init(initialState: FootstepHistoryFeature.State()) {
            FootstepHistoryFeature.preview()
        }
    )
}
