//
//  AddEditEventViewModel.swift
//  USkateAppV2
//
//  Created by Oleg Bragin on 15.03.2026.
//

import Foundation
import Observation

@MainActor
@Observable
final class AddEditEventViewModel {
    var isPresented: Bool = false
    var selectedDay: Date?
    var eventId: Int64 = 0
    var eventName: String = "1"
    var selectedColor: ColorOption?
    var timestamp: UUID?
    
    var event: EventDataSource?
    
    func save() -> Bool {
        guard
            let selectedDay,
            !eventName.isEmpty,
            let selectedColor
        else { return false }
        event = EventDataSource(
            id: eventId,
            name: eventName,
            date: selectedDay,
            color: selectedColor.colorName,
            timestamp: timestamp
        )
        return true
    }
    
    func reset() {
        eventId = 0
        eventName = ""
        selectedColor = nil
        selectedDay = nil
        event = nil
        isPresented = false
        timestamp = nil
    }
}
