//
//  USCalendarMonthModel.swift
//  USkateAppV2
//
//  Created by Oleg Bragin on 01.02.2026.
//

import Foundation
import Observation

@Observable
final class USCalendarMonthModel: Identifiable {
    let id = UUID()
    let monthProvider: USCalendarMonthProvider
    let label: String
    let number: Int
    
    let weeks: [USCalendarWeekModel]
    var selectedDay: USCalendarDayModel = .init(text: "sample1")
    
    init(monthProvider: USCalendarMonthProvider, columnCount: Int) {
        self.monthProvider = monthProvider
        self.weeks = monthProvider.weeks.enumerated().map {
            USCalendarWeekModel(
                weekNumber: $0.offset,
                monthNumber: monthProvider.month,
                year: monthProvider.year,
                days: $0.element.days,
                columnCount: columnCount,
            )
        }
        self.label = monthProvider.shortLocalizedMonthName()
        self.number = monthProvider.month
    }
}
