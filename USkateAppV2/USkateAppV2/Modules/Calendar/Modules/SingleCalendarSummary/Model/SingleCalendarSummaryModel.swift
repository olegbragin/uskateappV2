//
//  Untitled.swift
//  USkateAppV2
//
//  Created by Oleg Bragin on 05.02.2026.
//

import Foundation
import Observation

@Observable
final class SingleCalendarSummaryModel {
    var events: [SummaryEventModel]
    let year: Int
    
    init(
        year: Int,
        events: [SummaryEventModel]
    ) {
        self.year = year
        self.events = events
    }
}
