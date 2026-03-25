//
//  SwiftUIView.swift
//  USkateAppV2
//
//  Created by Oleg Bragin on 25.01.2026.
//

import SwiftUI

struct USCalendarWeekView: View {
    // Для тактильной отдачи
    private let hapticFeedback = UINotificationFeedbackGenerator()
    
    @Bindable var viewModel: USCalendarWeekModel
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(viewModel.days, id: \.id) { day in
                USCalendarDayView(
                    model: day
                )
                .padding(.bottom, 0)
                .onTapGesture {
                    viewModel.select(day: day.dateComponents?.date)
                }
                .onLongPressGesture(
                    minimumDuration: 3.5,
                    pressing: { isPressing in
                        if isPressing {
                            viewModel.selectionMode = .multiple
                            hapticFeedback.notificationOccurred(.success)
                        }
                    },
                    perform: {}
                )
            }
        }
        .onChange(of: viewModel.selectionMode) { oldValue, newValue in
            if oldValue != newValue, newValue == .multiple {
                hapticFeedback.notificationOccurred(.success)
            }
        }
    }
}

#Preview {
    USCalendarWeekView(
        viewModel: .init(
            dto: .init(
                number: 4,
                days: [
                    .init(dateComponents: DateComponents(year: 2024, month: 1, day: 1), number: 44, isInCurrentMonth: true, isToday: false),
                    .init(dateComponents: DateComponents(year: 2024, month: 1, day: 1), number: 43, isInCurrentMonth: true, isToday: false),
                    .init(dateComponents: DateComponents(year: 2024, month: 1, day: 1), number: 44, isInCurrentMonth: true, isToday: false),
                    .init(dateComponents: DateComponents(year: 2024, month: 1, day: 1), number: 43, isInCurrentMonth: true, isToday: false),
                    .init(dateComponents: DateComponents(year: 2024, month: 1, day: 1), number: 45, isInCurrentMonth: true, isToday: false),
                    .init(dateComponents: DateComponents(year: 2024, month: 1, day: 1), number: 44, isInCurrentMonth: true, isToday: false),
                    .init(dateComponents: DateComponents(year: 2024, month: 1, day: 1), number: 45, isInCurrentMonth: true, isToday: true),
                ]
            )
        )
    )
}
