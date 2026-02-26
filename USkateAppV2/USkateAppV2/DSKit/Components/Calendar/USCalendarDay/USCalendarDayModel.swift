//
//  USCalendarDayModel.swift
//  USkateAppV2
//
//  Created by Oleg Bragin on 01.02.2026.
//

import Foundation
import SwiftUI

@Observable
final class USCalendarDayModel: Identifiable {
    let id = UUID()
    
    let text: String
    let isDayNumber: Bool
    let isToday: Bool
    let isInCurrentMonth: Bool
    let columnCount: Int
    let date: Date?
    var events: [Color]
    
    init(
        text: String,
        isToday: Bool = false,
        isInCurrentMonth: Bool = false,
        columnCount: Int = 1,
        date: Date? = nil,
        events: [Color] = [],
        isDayNumber: Bool = true
    ) {
        self.text = text
        self.isToday = isToday
        self.isInCurrentMonth = isInCurrentMonth
        self.columnCount = columnCount
        self.date = date
        self.events = events
        self.isDayNumber = isDayNumber
    }
}
