//
//  Untitled.swift
//  USkateAppV2
//
//  Created by Oleg Bragin on 04.02.2026.
//

import Foundation
import Observation

@Observable
final class SingleCalendarModel: Identifiable {
    let id: Int64
    var label: String
    var numberOfColumns: Int
    var year: Int
    let manager = CalendarManager()
    
    init(id: Int64, label: String = "", numberOfColumns: Int = 1, year: Int = 2026) {
        self.id = id
        self.label = label
        self.numberOfColumns = numberOfColumns
        self.year = year
    }
    
    func addEvent(id: Int64, name: String, date: Date, color: String) async throws {
        let newEvent = EventDataSource(id: id, name: name, date: date, color: color)
        try await manager.addEditEvent(newEvent, calendarId: self.id)
    }
    
    func calendarEvents() async throws -> [EventDataSource] {
        try await manager.getCalendar(id: id)?.events ?? []
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
