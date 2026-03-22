//
//  SwiftUIView.swift
//  USkateAppV2
//
//  Created by Oleg Bragin on 25.01.2026.
//

import SwiftUI

struct USCalendarWeekView: View {
    @Bindable var model: USCalendarWeekModel
    @Binding var selectedDay: Date?
    @Binding var isLongPressed: Bool
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(model.days) { day in
                USCalendarDayView(
                    model: day
                )
                .padding(.bottom, 0)
                .onTapGesture {
                    selectedDay = day.date
                }
                .onLongPressGesture(
                    minimumDuration: 2.5,
                    pressing: { isPressing in
                        if isPressing {
                            isLongPressed = true
                        }
                    },
                    perform: {}
                )
            }
        }
    }
}

#Preview {
    USCalendarWeekView(
        model: .init(
            weekNumber: 1,
            monthNumber: 1,
            year: 2026,
            days: [
                .init(date: Date(), number: 1, isInCurrentMonth: true, isToday: true, events: []),
                .init(date: Date(), number: 1, isInCurrentMonth: false, isToday: true),
                .init(date: Date(), number: 1, isInCurrentMonth: true, isToday: false),
                .init(date: Date(), number: 1, isInCurrentMonth: false, isToday: false),
                .init(date: Date(), number: 1, isInCurrentMonth: false, isToday: false),
                .init(date: Date(), number: 1, isInCurrentMonth: false, isToday: false),
                .init(date: Date(), number: 1, isInCurrentMonth: false, isToday: false)
            ],
            columnCount: 2
        ),
        selectedDay: .constant(nil),
        isLongPressed: .constant(false)
    )
}
