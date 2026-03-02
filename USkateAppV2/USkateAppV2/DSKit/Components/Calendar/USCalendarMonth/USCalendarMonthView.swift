//
//  USCalendarMonth.swift
//  USkateAppV2
//
//  Created by Oleg Bragin on 25.01.2026.
//

import SwiftUI

struct USCalendarMonthView: View {
    @Bindable var model: USCalendarMonthModel
    @Binding var selectedDay: Date?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(model.label)
            VStack(alignment: .leading, spacing: 0) {
                USCalendarWeekHeaderView()
                    .padding(.bottom, 0)
                ForEach(model.weeks) { week in
                    USCalendarWeekView(
                        model: week,
                        selectedDay: $selectedDay
                    )
                }
            }
        }
    }
}

#Preview {
    USCalendarMonthView(
        model: .init(monthProvider: .init(month: 1, year: 2026), columnCount: 3),
        selectedDay: .constant(Date())
    )
}
