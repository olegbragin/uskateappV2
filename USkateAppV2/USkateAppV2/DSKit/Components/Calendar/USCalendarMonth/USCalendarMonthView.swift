//
//  USCalendarMonth.swift
//  USkateAppV2
//
//  Created by Oleg Bragin on 25.01.2026.
//

import SwiftUI
import OrderedCollections

struct USCalendarMonthView: View {
    let model: USCalendarMonthModel
    
    init(model: USCalendarMonthModel) {
        self.model = model
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(model.label)
            VStack(alignment: .leading, spacing: 0) {
                USCalendarWeekHeaderView()
                ForEach(model.weeks) { week in
                    USCalendarWeekView(model: week)
                }
            }
        }
    }
}

#Preview {
    USCalendarMonthView(
        model: .init(monthProvider: .init(month: 1, year: 2026))
    )
}
