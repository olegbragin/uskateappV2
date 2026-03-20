//
//  Untitled.swift
//  USkateAppV2
//
//  Created by Oleg Bragin on 04.02.2026.
//

import Foundation
import Observation

@Observable
final class SingleCalendarModel {
    private let manager = CalendarManager()
    
    let id: Int64
    
    var label: String = ""
    var selectedMonth: Int = 0
    var selectedDay: Date?
    var yearModel: USCalendarYearModel = .init(year: 2026, numberOfColumns: 1)
    var addEditEventModel = AddEditEventViewModel()
    var legendViewModel = SingleCalendarSummaryModel(year: 2026, events: [])
    
    var selectedEvents: [EventDataSource] {
        guard let selectedDay else { return yearModel.events }
        return yearModel.events.filter {
            $0.date == selectedDay
        }
    }
    
    init(id: Int64) {
        self.id = id
    }
    
    func fetch() async throws {
        guard let persistedCalendar = try? await self.manager.getCalendar(id: self.id) else { return }
        await MainActor.run {
            self.label = persistedCalendar.name
            self.yearModel.year = persistedCalendar.year
            self.yearModel.columnCount = persistedCalendar.numberOfColumns
            self.yearModel.events = persistedCalendar.events
            
            self.addEditEventModel.selectedDay = selectedDay
            self.legendViewModel = SingleCalendarSummaryModel(year: yearModel.year, events: group(events: yearModel.events))
        }
    }
    
    func addEvent(id: Int64, name: String, date: Date, color: String) async throws {
        let newEvent = EventDataSource(id: id, name: name, date: date, color: color)
        try await manager.addEditEvent(newEvent, calendarId: self.id)
    }
    
    func removeEvents(ids: [Int64]) async throws {
        try await manager.removeEvents(ids, calendarId: self.id)
        yearModel.events.removeAll(where: { ids.contains($0.id) })
    }
    
    func save() {
        Task {
            guard var persistedCalendar = try? await self.manager.getCalendar(id: self.id) else { return }
            persistedCalendar.numberOfColumns = yearModel.columnCount
            try? await manager.updateCalendar(persistedCalendar)
        }
    }
    
    func cancel() {
        selectedDay = nil
    }
    
    private func group(events: [EventDataSource]) -> [SummaryEventModel] {
        Dictionary(grouping: events, by: { $0.color }).reduce(into: [SummaryEventModel]()) {
            $0.append(
                .init(
                    labels:
                        $1.value.map {
                            (id: $0.id, name: $0.name)
                        },
                    color: $1.key
                )
            )
        }
        .sorted {
            $0.labels.count > $1.labels.count
        }
    }
}

extension SingleCalendarModel: Equatable {
    static func == (lhs: SingleCalendarModel, rhs: SingleCalendarModel) -> Bool {
        lhs.id == rhs.id
    }
}

extension SingleCalendarModel: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
