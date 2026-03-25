//
//  USCalendarMonth.swift
//  USkateAppV2
//
//  Created by Oleg Bragin on 25.01.2026.
//

import SwiftUI

struct USCalendarMonthView: View {
    @Bindable var viewModel: USCalendarMonthModel
    
    var body: some View {
        LazyVStack(alignment: .leading, spacing: 8) {
            Text(viewModel.label)
            LazyVStack(alignment: .leading, spacing: 0) {
                USCalendarWeekHeaderView(viewModel: .init(weekSymbols: viewModel.weekDaySymbols))
                    .padding(.bottom, 0)
                ForEach(viewModel.weeks) { week in
                    USCalendarWeekView(
                        viewModel: week
                    )
                    .onChange(of: week.selectedDays) { oldValue, newValue in
                        viewModel.selectedDays = week.selectedDays
                        // model.selectionMode = week.selectionMode
                        // model.isLongPressed = week.isLongPressed
                    }
                }
            }
        }
    }
}

#Preview {
    USCalendarMonthView(
        viewModel: .init(
            dto: .init(
                number: 1,
                label: "Jan",
                weekDaySymbols: ["S"],
                weeks: []
            )
        )
    )
}
