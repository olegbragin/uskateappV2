//
//  SingleDayModel.swift
//  USkateAppV2
//
//  Created by Oleg Bragin on 04.02.2026.
//

import Foundation
import Observation

@Observable
final class SingleCalendarDetailViewModel {
    private let id: Int64
    private let selectedMonth: Int
    private let manager: CalendarManager
    
    var name: String = ""
    var year: Int = 2026
    var numberOfColumns: Int = 1
    
    var events: [EventDataSource] = []
    var currentMonthIndex: Int = 0
    var summary: SingleCalendarSummaryModel = .init(year: 2026, events: [])
    
    init(id: Int64, selectedMonth: Int, manager: CalendarManager) {
        self.id = id
        self.selectedMonth = selectedMonth
        self.manager = manager
    }
    
    func fetch() async throws {
        let calendar = try await manager.getCalendar(id: id)
        name = calendar?.name ?? ""
        year = calendar?.year ?? 2026
        numberOfColumns = calendar?.numberOfColumns ?? 1
        currentMonthIndex = selectedMonth
        events = calendar?.events ?? []
        summary = SingleCalendarSummaryModel(
            year: year,
            events: (calendar?.events ?? []).map {
                .init(label: $0.name, color: $0.color, date: $0.date, numberOfEvents: 4)
            }
        )
    }
}
