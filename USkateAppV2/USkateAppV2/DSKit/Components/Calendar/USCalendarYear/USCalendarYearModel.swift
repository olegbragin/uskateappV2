//
//  USCalendarYearModel.swift
//  USkateAppV2
//
//  Created by Oleg Bragin on 01.02.2026.
//

import Combine
import SwiftUI

@Observable
final class USCalendarYearModel {
    private let numberOfCurrentMonth: Int
    
    // Для тактильной отдачи (опционально)
    private let hapticFeedback = UINotificationFeedbackGenerator()
    
    var numberOfColumns: Int = 1
    var scrollPosition: CGFloat = 0
    
    var selectedDays: Set<Date> = []
    var selectionMode: USCalendarSelectionMode = .single
    var isLongPressEnabled: Bool = false
    
    var indexOfCurrentMonth: Int? {
        return months.firstIndex { $0.number == numberOfCurrentMonth }
    }

    var months: [USCalendarMonthModel] = []
    
    init(months: [USCalendarMonthDataSource], numberOfCurrentMonth: Int, numberOfColumns: Int = 1) {
        self.numberOfColumns = numberOfColumns
        self.numberOfCurrentMonth = numberOfCurrentMonth
        self.months = months.map {
            .init(dto: $0)
        }
    }
    
    func toggleSelectionMode() {
        let currentSelectionMode = selectionMode
        selectionMode = currentSelectionMode == .single ? .multiple : .single
    }

    func reset() {
        numberOfColumns = 2
    }
}
