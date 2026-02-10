//
//  USCalendarMonthModel.swift
//  USkateAppV2
//
//  Created by Oleg Bragin on 01.02.2026.
//

import Foundation

struct USCalendarMonthModel: Identifiable {
    let id = UUID()
    let monthProvider: USCalendarMonthProvider
    let label: String
    
    let weeks: [USCalendarWeekModel]
    
    init(monthProvider: USCalendarMonthProvider, columnCount: Int) {
        self.monthProvider = monthProvider
        self.weeks = monthProvider.weeks.enumerated().map {
            USCalendarWeekModel(
                weekNumber: $0.offset,
                monthNumber: monthProvider.month,
                year: monthProvider.year,
                days: $0.element.days,
                columnCount: columnCount
            )
        }
        self.label = monthProvider.shortLocalizedMonthName()
    }
}
