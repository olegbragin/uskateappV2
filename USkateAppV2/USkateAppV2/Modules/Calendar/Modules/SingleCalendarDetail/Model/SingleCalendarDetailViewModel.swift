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
    let id: Int64
    private let selectedMonth: Int
    private let manager: CalendarManager
    
    var name: String = ""
    var year: Int = 2026
    var numberOfColumns: Int = 1
    
    var selectedDay: Date?
    var selectedColor: ColorOption?
    var eventName: String = ""
    
    var events: [EventDataSource] = []
    var currentMonthIndex: Int = 0
    var summary = SingleCalendarSummaryModel(year: 2026, events: [])
    
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
            events: group(events: events)
        )
    }
    
    func addEvent(id: Int64, name: String, date: Date, color: String) async throws {
        let newEvent = EventDataSource(id: id, name: name, date: date, color: color)
        try await manager.addEditEvent(newEvent, calendarId: self.id)
        events = try await calendarEvents()
    }
    
    private func calendarEvents() async throws -> [EventDataSource] {
        try await manager.getCalendar(id: id)?.events ?? []
    }
    
    private func group(events: [EventDataSource]) -> [SummaryEventModel] {
        Dictionary(grouping: events, by: { $0.color }).reduce(into: [SummaryEventModel]()) {
            $0.append(
                .init(
                    label:
                        $1.value.map {
                            $0.name
                        }
                        .joined(separator: ", "),
                    color: $1.key,
                    numberOfEvents: $1.value.count
                )
            )
        }
        .sorted {
            $0.numberOfEvents > $1.numberOfEvents
        }
    }
    
    func commit() async throws {
        if !eventName.isEmpty, let selectedColor, let selectedDay {
            try await addEvent(id: 0, name: eventName, date: selectedDay, color: selectedColor.colorName)
            try await fetch()
        }
        selectedDay = nil
    }
    
    func cancel() {
        selectedDay = nil
    }
}
