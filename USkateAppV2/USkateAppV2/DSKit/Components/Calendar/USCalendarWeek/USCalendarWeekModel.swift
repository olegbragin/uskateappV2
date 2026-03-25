//
//  USCalendarWeekModel.swift
//  USkateAppV2
//
//  Created by Oleg Bragin on 28.01.2026.
//

import Foundation
import SwiftUI

@Observable
final class USCalendarWeekModel: Identifiable {
    let id = UUID()
    let days: [USCalendarDayModel]
    
    var selectedDays: Set<Date> = []
    var selectionMode: USCalendarSelectionMode = .single
    var isLongPressed: Bool = false
    
    init(dto: USCalendarWeekDataSource) {
        self.days = dto.days.map {
            USCalendarDayModel(dto: $0)
        }
    }
    
    func select(day: Date?) {
        guard let selectedDay = day else { return }
        switch selectionMode {
        case .single:
            selectedDays.removeAll()
            selectedDays.insert(selectedDay)
        case .multiple:
            if !selectedDays.contains(selectedDay) {
                selectedDays.insert(selectedDay)
            } else {
                selectedDays.remove(selectedDay)
            }
        }
    }
}
