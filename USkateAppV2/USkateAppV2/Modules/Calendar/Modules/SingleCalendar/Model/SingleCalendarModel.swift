//
//  Untitled.swift
//  USkateAppV2
//
//  Created by Oleg Bragin on 04.02.2026.
//

import Combine

final class SingleCalendarModel: ObservableObject {
    @Published var label: String
    @Published var numberOfColumns: Int
    @Published var year: Int
    
    init(label: String = "", numberOfColumns: Int = 1, year: Int = 2026) {
        self.label = label
        self.numberOfColumns = numberOfColumns
        self.year = year
    }
}
