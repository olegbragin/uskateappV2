//
//  Navigatino.swift
//  USkateAppV2
//
//  Created by Oleg Bragin on 19.02.2026.
//

enum RootSelection: Equatable, Hashable {
    case calendarList
    case calendarGallery(selectedCalendarId: Int64)
    case calendarDetails(selectedCalendar: SingleCalendarModel)
}
