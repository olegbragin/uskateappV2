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
                        if oldValue != newValue {
                            viewModel.selectedDays = newValue
                        }
                        // viewModel.selectionMode = week.selectionMode
                        // model.isLongPressed = week.isLongPressed
                    }
                    .onChange(of: week.selectionMode) { oldValue, newValue in
                        if oldValue != newValue {
                            viewModel.selectionMode = newValue
                        }
                        // viewModel.selectionMode = week.selectionMode
                        // model.isLongPressed = week.isLongPressed
                    }
                }
            }
        }
        .onChange(of: viewModel.selectionMode) { oldValue, newValue in
            if oldValue != newValue {
                viewModel.weeks.forEach {
                    $0.selectionMode = newValue
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
