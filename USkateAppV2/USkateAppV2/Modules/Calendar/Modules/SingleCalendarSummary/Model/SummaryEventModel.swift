//
//  SummaryEventModel.swift
//  USkateAppV2
//
//  Created by Oleg Bragin on 05.02.2026.
//

import Foundation
import Observation

@Observable
final class SummaryEventModel: Identifiable {
    let id = UUID()
    let labels: [(id: Int64, name: String)]
    let color: String
    
    init(
        labels: [(id: Int64, name: String)] = [],
        color: String = ""
    ) {
        self.labels = labels
        self.color = color
    }
}
