//
//  CalendarsModel.swift
//  USkateAppV2
//
//  Created by Oleg Bragin on 04.02.2026.
//

import Observation

@Observable
final class CalendarsModel {
    let persistedCalendars: [SingleCalendarModel]
    
    init(persistedCalendars: [SingleCalendarModel] = []) {
        self.persistedCalendars = [
            SingleCalendarModel(label: "Super Cal 1"),
            SingleCalendarModel(label: "Super Cal 2", numberOfColumns: 2),
            SingleCalendarModel(label: "Super Cal 3", numberOfColumns: 3)
        ]
    }
}
