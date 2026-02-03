//
//  USCalendarYear.swift
//  USkateAppV2
//
//  Created by Oleg Bragin on 25.01.2026.
//

import SwiftUI

struct USCalendarYearView: View {
    private let model: USCalendarYearModel
    
    init (model: USCalendarYearModel) {
        self.model = model
    }
    
    var body: some View {
        LazyVGrid(
            columns: Array(
                repeating: GridItem(.flexible(), spacing: 12),
                count: model.numberOfColumnsToShow
            ),
            spacing: 32
        ) {
            ForEach(model.months) {
                USCalendarMonthView(model: $0)
            }
        }
        .padding(16)
    }
}

#Preview {
    USCalendarYearView(
        model: .init(numberOfColumnsToShow: 2)
    )
}
