//
//  CalendarListView.swift
//  USkateAppV2
//
//  Created by Oleg Bragin on 19.02.2026.
//

import Observation

@Observable
final class CalendarListViewModel {
    private var manager: CalendarManager
    
    var calendars: [CalendarListModel] = []
    
    init(manager: CalendarManager = .init()) {
        self.manager = manager
    }
    
    func fetch() async throws {
        self.calendars = try await manager.getAllCalendars().map {
            CalendarListModel($0)
        }
    }
    
    func addCalendar(with name: String) {
        Task {
            let newCalendar = try await manager.createCalendar(name: name, year: 2026, numberOfColumns: 3)
            await MainActor.run {
                self.calendars.append(CalendarListModel(newCalendar))
            }
        }
    }
    
    func removeCalendar(_ calendar: CalendarListModel) {
        Task {
            try await manager.deleteCalendar(calendar.id)
            await MainActor.run {
                self.calendars.removeAll {
                    $0.id == calendar.id
                }
            }
        }
    }
}
