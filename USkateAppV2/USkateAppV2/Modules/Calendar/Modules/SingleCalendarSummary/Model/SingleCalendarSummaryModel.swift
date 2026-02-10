//
//  Untitled.swift
//  USkateAppV2
//
//  Created by Oleg Bragin on 05.02.2026.
//

import Foundation

struct SingleCalendarSummaryModel {
    let label: String
    let events: [SummaryEventModel]
    let year: Date
    
    init(
        label: String,
        year: Date,
        events: [SummaryEventModel]
    ) {
        self.label = label
        self.year = year
        self.events = events
    }
}
