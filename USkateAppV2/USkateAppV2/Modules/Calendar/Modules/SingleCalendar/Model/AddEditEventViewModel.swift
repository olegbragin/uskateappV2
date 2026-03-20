//
//  AddEditEventViewModel.swift
//  USkateAppV2
//
//  Created by Oleg Bragin on 15.03.2026.
//

import Foundation
import Observation

@Observable
final class AddEditEventViewModel {
    var selectedDay: Date?
    var eventId: Int64 = 0
    var eventName: String = ""
    var selectedColor: ColorOption?
    
    var event: EventDataSource?
    
    func save() -> Bool {
        guard
            let selectedDay,
            !eventName.isEmpty,
            let selectedColor
        else { return false }
        event = EventDataSource(id: eventId, name: eventName, date: selectedDay, color: selectedColor.colorName)
        return true
    }
    
    func reset() {
        eventId = 0
        eventName = ""
        selectedColor = nil
    }
    
    func cancel() {
        selectedDay = nil
    }
}
