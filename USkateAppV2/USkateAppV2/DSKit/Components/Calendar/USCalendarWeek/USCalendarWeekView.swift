//
//  SwiftUIView.swift
//  USkateAppV2
//
//  Created by Oleg Bragin on 25.01.2026.
//

import SwiftUI

struct USCalendarWeekView: View {
    let model: USCalendarWeekModel
    
    init(model: USCalendarWeekModel) {
        self.model = model
    }
    
    var body: some View {
        HStack(spacing: 4) {
            ForEach(model.days) {
                USCalendarDayView(
                    model: $0
                )
                .background(backgroundColor(for: $0))
                .border(backgroundColor(for: $0), width: 0.5)
                .clipShape(
                    RoundedRectangle(cornerRadius: 8)
                )
                .aspectRatio(1, contentMode: .fit)
                .padding(.bottom, 4)
            }
        }
    }
    
    private func backgroundColor(for day: USCalendarDayModel) -> Color {
        switch (day.isToday, day.isInCurrentMonth) {
        case (true, true), (true, false):
            return .red
        case (false, true):
            return Color("colorBackground")
        case (false, false):
            return Color("colorBackgroundDisabled")
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
                .init(date: Date(), number: 1, isInCurrentMonth: true, isToday: true),
                .init(date: Date(), number: 1, isInCurrentMonth: false, isToday: true),
                .init(date: Date(), number: 1, isInCurrentMonth: true, isToday: false),
                .init(date: Date(), number: 1, isInCurrentMonth: false, isToday: false),
                .init(date: Date(), number: 1, isInCurrentMonth: false, isToday: false),
                .init(date: Date(), number: 1, isInCurrentMonth: false, isToday: false),
                .init(date: Date(), number: 1, isInCurrentMonth: false, isToday: false)
            ]
        )
    )
}
