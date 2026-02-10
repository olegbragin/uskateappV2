//
//  USCalendarWeekModel.swift
//  USkateAppV2
//
//  Created by Oleg Bragin on 28.01.2026.
//

import Foundation

struct USCalendarWeekModel: Identifiable {
    let id = UUID()
    
    let weekNumber: Int
    let monthNumber: Int
    let year: Int
    let days: [USCalendarDayModel]
    
    init(weekNumber: Int, monthNumber: Int, year: Int, days: [USCalendarDayDataSource] = [], columnCount: Int) {
        self.weekNumber = weekNumber
        self.monthNumber = monthNumber
        self.year = year
        self.days = days.map {
            USCalendarDayModel(
                text: "\($0.number)",
                isToday: $0.isToday,
                isInCurrentMonth: $0.isInCurrentMonth,
                columnCount: columnCount
            )
        }
    }
}
