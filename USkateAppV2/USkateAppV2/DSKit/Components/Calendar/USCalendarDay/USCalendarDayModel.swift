//
//  USCalendarDayModel.swift
//  USkateAppV2
//
//  Created by Oleg Bragin on 01.02.2026.
//

import Foundation

struct USCalendarDayModel: Identifiable {
    let id = UUID()
    
    let text: String
    let isToday: Bool
    let isInCurrentMonth: Bool
    let columnCount: Int
    
    init(
        text: String,
        isToday: Bool = false,
        isInCurrentMonth: Bool = false,
        columnCount: Int
    ) {
        self.text = text
        self.isToday = isToday
        self.isInCurrentMonth = isInCurrentMonth
        self.columnCount = columnCount
    }
}
