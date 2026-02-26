//
//  CalendarDataSource.swift
//  USkateAppV2
//
//  Created by Oleg Bragin on 15.02.2026.
//

import ObjectBox

struct CalendarDataSource {
    var id: Int64
    var name: String
    var year: Int
    var numberOfColumns: Int
    var events: [EventDataSource]
    
    init(
        id: Int64 = 0,
        name: String,
        year: Int,
        numberOfColumns: Int,
        events: [EventDataSource] = []
    ) {
        self.id = id
        self.name = name
        self.year = year
        self.numberOfColumns = numberOfColumns
        self.events = events
    }
    
    init?(_ dto: PPCalendar?) {
        guard let dto else { return nil }
        self.id = Int64(dto.id)
        self.name = dto.name
        self.year = dto.year
        self.numberOfColumns = dto.numberOfColumns
        self.events = dto.events.compactMap {
            EventDataSource($0)
        }
    }
}
