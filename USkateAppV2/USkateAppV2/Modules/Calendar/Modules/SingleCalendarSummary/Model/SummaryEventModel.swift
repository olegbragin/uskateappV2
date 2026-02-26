//
//  SummaryEventModel.swift
//  USkateAppV2
//
//  Created by Oleg Bragin on 05.02.2026.
//

import Foundation

struct SummaryEventModel: Identifiable {
    let id = UUID()
    let numberOfEvents: Int
    let label: String
    let color: String
    let date: Date
    
    init(
        label: String,
        color: String,
        date: Date,
        numberOfEvents: Int
    ) {
        self.label = label
        self.color = color
        self.date = date
        self.numberOfEvents = numberOfEvents
    }
}
