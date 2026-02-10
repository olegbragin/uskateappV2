//
//  SummaryNumberOfEventsModel.swift
//  USkateAppV2
//
//  Created by Oleg Bragin on 05.02.2026.
//

struct SummaryNumberOfEventsModel {
    private let numberOfEvents: Int
    
    var text: String {
        numberOfEvents > 9 ? "9+" : "\(numberOfEvents)"
    }
    
    init(numberOfEvents: Int) {
        self.numberOfEvents = numberOfEvents
    }
}
