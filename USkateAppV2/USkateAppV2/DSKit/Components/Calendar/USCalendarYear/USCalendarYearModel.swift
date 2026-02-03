//
//  USCalendarYearModel.swift
//  USkateAppV2
//
//  Created by Oleg Bragin on 01.02.2026.
//

struct USCalendarYearModel {
    var numberOfColumnsToShow: Int = 3
    let months: [USCalendarMonthModel] = [
        .init(monthProvider: .init(month: 1, year: 2026)),
        .init(monthProvider: .init(month: 2, year: 2026)),
        .init(monthProvider: .init(month: 3, year: 2026)),
        .init(monthProvider: .init(month: 4, year: 2026)),
        .init(monthProvider: .init(month: 5, year: 2026)),
        .init(monthProvider: .init(month: 6, year: 2026)),
        .init(monthProvider: .init(month: 7, year: 2026)),
        .init(monthProvider: .init(month: 8, year: 2026)),
        .init(monthProvider: .init(month: 9, year: 2026)),
        .init(monthProvider: .init(month: 10, year: 2026)),
        .init(monthProvider: .init(month: 11, year: 2026)),
        .init(monthProvider: .init(month: 12, year: 2026))
    ]
}
