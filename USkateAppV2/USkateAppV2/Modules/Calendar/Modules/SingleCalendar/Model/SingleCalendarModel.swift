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
    enum Action {
        case change
        case delete
    }
    
    private let dataProvider = USCalendarDataProvider()
    private let manager = CalendarManager()
    
    private var task: Task<Void, Never>?
    private var originalEvents: Set<EventDataSource> = []
    private var addedEvents: Set<EventDataSource> = []
    
    private(set) var label: String = ""
    
    var selectedColor: ColorOption?
    
    var yearModel = USCalendarYearModel(months: [], numberOfCurrentMonth: 1)
    var legendViewModel = SingleCalendarSummaryModel(year: 2026, events: [])
    var editListViewModel = EventListViewModel()
    
    var isLoading = false
    var isEditSheetPresented = false
    var isLegendSheetPresented = false
    
    var selectedEvents: [EventDataSource] {
        guard !yearModel.selectedDays.isEmpty else { return [] }
        return originalEvents.filter { event in
            yearModel.selectedDays.contains { date in
                let dayDate = event.date
                let eventDateComponents = dataProvider.dateComponents(forDate: dayDate)
                let dayComponents = dataProvider.dateComponents(forDate: date)
                return
                    dayComponents.day == eventDateComponents.day &&
                    dayComponents.month == eventDateComponents.month &&
                    dayComponents.year == eventDateComponents.year
            }
        }
    }
    
    func changeEvent(_ event: EventDataSource) {
        if addedEvents.contains(event) {
            addedEvents.remove(at: addedEvents.firstIndex(of: event)!)
        } else {
            addedEvents.insert(event)
        }
        updateYearModel(with: originalEvents.union(addedEvents))
        yearModel.selectedDays = []
    }
    
    func fetch(for calendarId: Int64) {
        reset()
        
        guard !isLoading, !Task.isCancelled else { return }
        isLoading = true
        
        task?.cancel()
        task = Task {
            guard let calendar = try? await self.manager.getCalendar(id: calendarId) else {
                isLoading = false
                return
            }
            
            await MainActor.run {
                label = calendar.name
                yearModel.months = dataProvider.months(forYear: calendar.year).map {
                    USCalendarMonthModel(dto: $0)
                }
                yearModel.numberOfCurrentMonth = dataProvider.numberOfCurrentMonth
                yearModel.set(initialNumberOfColumns: calendar.numberOfColumns)
                
                legendViewModel.year = calendar.year
                legendViewModel.events = Self.group(events: calendar.events)
                
                originalEvents = Set(calendar.events)
                updateYearModel(with: originalEvents)
                isLoading = false
            }
        }
    }
    
    func save(for calendarId: Int64) {
        Task {
            guard var persistedCalendar = try? await self.manager.getCalendar(id: calendarId) else { return }
            persistedCalendar.numberOfColumns = yearModel.numberOfColumns
            persistedCalendar.events = Array(originalEvents)
            try? await manager.updateCalendar(persistedCalendar)
        }
    }
    
    func commitMultipleChanges(for calendarId: Int64) {
        let allEvents = originalEvents.union(addedEvents)
        originalEvents = allEvents
        
        updateYearModel(with: allEvents)
        yearModel.toggleSelectionMode()
        addedEvents = []
        save(for: calendarId)
    }
    
    func cancelMultipleChanges() {
        updateYearModel(with: originalEvents)
        yearModel.toggleSelectionMode()
        addedEvents = []
    }
    
    func prepareEditListViewModel(with selectedDays: Set<Date>) {
        editListViewModel.prepare(with: selectedEvents, and: selectedDays.first)
        isEditSheetPresented = selectedDays.first != nil
    }
    
    func apply(events: [EventDataSource], action: Action, for calendarId: Int64) {
        switch action {
        case .change:
            let newEvents = mergeSetsByID(Set(originalEvents), with: Set(events))
            originalEvents = newEvents
            updateYearModel(with: originalEvents)
        case .delete:
            events.forEach {
                originalEvents.remove($0)
            }
            updateYearModel(with: originalEvents)
        }
        save(for: calendarId)
        prepareEditListViewModel(with: yearModel.selectedDays)
    }
    
    func reset() {
        label = ""
        isLoading = false
        isEditSheetPresented = false
        isLegendSheetPresented = false
    }
    
    func resetSelectedDays() {
        yearModel.selectedDays = []
        editListViewModel.cancel()
    }
    
    private func mergeSetsByID<T: Hashable & Identifiable>(
        _ originalSet: Set<T>,
        with updates: Set<T>
    ) -> Set<T> {
        // Шаг 1: преобразуем исходный набор в словарь по ID
        var dictionary = Dictionary(uniqueKeysWithValues: originalSet.map { ($0.id, $0) })

        // Шаг 2: обновляем словарь объектами из updates — дубли по ID перезапишутся
        updates.forEach { update in
            dictionary[update.id] = update
        }

        // Шаг 3: возвращаем новый Set
        return Set(dictionary.values)
    }
    
    private func updateYearModel(with events: Set<EventDataSource>) {
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
