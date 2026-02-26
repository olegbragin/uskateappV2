//
//  Untitled.swift
//  USkateAppV2
//
//  Created by Oleg Bragin on 15.02.2026.
//

import Foundation

struct EventDataSource: Identifiable {
    var id: Int64
    var name: String
    var color: String
    var date: Date
    
    init(id: Int64 = 0, name: String, date: Date, color: String) {
        self.id = id
        self.name = name
        self.date = date
        self.color = color
    }
    
    init?(_ dto: PPEvent?) {
        guard let dto else { return nil }
        self.id =  Int64(dto.id)
        self.name = dto.name
        self.date = dto.date
        self.color = dto.color
    }
}

extension EventDataSource: Equatable {
    static func == (lhs: EventDataSource, rhs: EventDataSource) -> Bool {
        lhs.id == rhs.id && lhs.name == rhs.name && lhs.date == rhs.date
    }
}
