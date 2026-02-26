//
//  CalendarsModel.swift
//  USkateAppV2
//
//  Created by Oleg Bragin on 04.02.2026.
//

import Observation

@Observable
final class CalendarsViewModel {
    private let manager: CalendarManager
    private var selectedCalendarId: Int64?
    
    var selection: RootSelection?
    var selectedIndex: Int = 0
    var calendars: [SingleCalendarModel] = []
    var selectedMonth: Int = 0
    var selectedCalendar: SingleCalendarModel? {
        guard selectedIndex < calendars.count else { return nil }
        return calendars[selectedIndex]
    }
    
    init(manager: CalendarManager, selectedCalendarId: Int64? = nil) {
        self.manager = manager
        self.selectedCalendarId = selectedCalendarId
    }
    
    func fetch() async {
        let calendars = try? await self.manager.getAllCalendars().map {
            SingleCalendarModel(
                id: Int64($0.id),
                label: $0.name,
                numberOfColumns: $0.numberOfColumns,
                year: $0.year
            )
        }
        await MainActor.run {
            self.calendars = calendars ?? []
            selectedIndex = calendars?.firstIndex(where: { $0.id == selectedCalendarId }) ?? 0
        }
    }
}
