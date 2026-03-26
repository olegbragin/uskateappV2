//
//  Untitled.swift
//  USkateAppV2
//
//  Created by Oleg Bragin on 04.02.2026.
//

import Foundation
import Observation
import SwiftUI

@Observable
final class SingleCalendarModel {
    private let dataProvider = USCalendarDataProvider()
    private let manager = CalendarManager()
    private var originalEvents: [EventDataSource] = []
    private var changedEvents: Set<EventDataSource> = []
    
    var selectedCalendar: CalendarDataSource
    
    var label: String = ""
    var selectedColor: ColorOption?
    
    var yearModel: USCalendarYearModel
    var addEditEventModel: AddEditEventViewModel
    var legendViewModel: SingleCalendarSummaryModel
    
    var selectedEvents: [EventDataSource] {
        guard !yearModel.selectedDays.isEmpty else { return [] }
        return originalEvents.filter {
            yearModel.selectedDays.contains($0.date)
        }
    }
    
    init(dto: CalendarDataSource) {
        selectedCalendar = dto
        label = dto.name
        yearModel = .init(
            months: dataProvider.months(forYear: dto.year),
            numberOfCurrentMonth: dataProvider.numberOfCurrentMonth,
            numberOfColumns: dto.numberOfColumns
        )
        addEditEventModel = AddEditEventViewModel()
        legendViewModel = SingleCalendarSummaryModel(year: dto.year, events: Self.group(events: dto.events))
        
        originalEvents = dto.events
        updateYearModel(with: originalEvents)
    }
    
    func addEvent(id: Int64, name: String, date: Date, color: String) async throws {
        let newEvent = EventDataSource(id: id, name: name, date: date, color: color)
        try await manager.addEditEvent(newEvent, calendarId: self.selectedCalendar.id)
    }
    
    func removeEvents(ids: [Int64]) async throws {
        try await manager.removeEvents(ids, calendarId: self.selectedCalendar.id)
        // yearModel.events.removeAll(where: { ids.contains($0.id) })
    }
    
    func changeEvent(_ event: EventDataSource) {
        if changedEvents.contains(event) {
            changedEvents.remove(at: changedEvents.firstIndex(of: event)!)
        } else {
            changedEvents.insert(event)
        }
        updateYearModel(with: originalEvents + changedEvents)
        yearModel.selectedDays = []
    }
    
    func saveCalendar() {
        Task {
            guard var persistedCalendar = try? await self.manager.getCalendar(id: self.selectedCalendar.id) else { return }
            persistedCalendar.numberOfColumns = yearModel.numberOfColumns
            try? await manager.updateCalendar(persistedCalendar)
        }
    }
    
    func commitMultipleChanges() {
        let allEvents = originalEvents + changedEvents
        selectedCalendar.events = allEvents
        originalEvents = selectedCalendar.events
        
        updateYearModel(with: allEvents)
        changedEvents.forEach { event in
            Task {
                try await addEvent(id: event.id, name: event.name, date: event.date, color: event.color)
            }
        }
        yearModel.toggleSelectionMode()
        changedEvents = []
    }
    
    func cancelMultipleChanges() {
        updateYearModel(with: originalEvents)
        yearModel.toggleSelectionMode()
        changedEvents = []
    }
    
    func cancel() {
        yearModel.selectedDays = []
    }
    
    private func updateYearModel(with events: [EventDataSource]) {
        yearModel.months.forEach { month in
            month.weeks.forEach { week in
                week.days
                    .filter { day in
                        day.isInCurrentMonth
                    }
                    .forEach { day in
                        let dayEvents = events.filter {
                            guard let dayDate = day.date else { return false }
                            let eventDateComponents = dataProvider.dateComponents(forDate: $0.date)
                            let dayComponents = dataProvider.dateComponents(forDate: dayDate)
                            return
                                dayComponents.day == eventDateComponents.day &&
                                dayComponents.month == eventDateComponents.month &&
                                dayComponents.year == eventDateComponents.year
                        }
                        day.events = dayEvents.map {
                            $0.color
                        }
                    }
            }
        }
    }
    
    private static func group(events: [EventDataSource]) -> [SummaryEventModel] {
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
        lhs.selectedCalendar.id == rhs.selectedCalendar.id
    }
}

extension SingleCalendarModel: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(selectedCalendar.id)
    }
}
