//
//  USCalendarDayDataSource.swift
//  USkateAppV2
//
//  Created by Oleg Bragin on 01.02.2026.
//

import Foundation
import SwiftUI

struct USCalendarDayDataSource {
    let dateComponents: DateComponents
    let number: Int
    let isInCurrentMonth: Bool
    let isToday: Bool
    
    init(dateComponents: DateComponents, number: Int, isInCurrentMonth: Bool, isToday: Bool) {
        self.dateComponents = dateComponents
        self.number = number
        self.isInCurrentMonth = isInCurrentMonth
        self.isToday = isToday
    }
}
