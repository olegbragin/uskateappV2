//
//  CalendarModel.swift
//  USkateAppV2
//
//  Created by Oleg Bragin on 19.02.2026.
//

struct CalendarListModel: Identifiable, Hashable {
    let id: Int64
    let name: String
    
    init(id: Int64 = 0, name: String) {
        self.id = id
        self.name = name
    }
    
    init(_ dto: CalendarDataSource) {
        self.id = Int64(dto.id)
        self.name = dto.name
    }
}
