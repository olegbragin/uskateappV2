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
                    viewModel.select(day: day)
                }
                .simultaneousGesture(
                    LongPressGesture()
                        .onEnded { _ in
                            viewModel.selectionMode = .multiple
                            hapticFeedback.notificationOccurred(.success)
                        },
                    isEnabled: viewModel.selectionMode == .single
                )
            }
        }
        .onChange(of: viewModel.selectionMode) { oldValue, newValue in
            if oldValue != newValue, newValue == .multiple {
                hapticFeedback.notificationOccurred(.success)
            }
        }
        .onChange(of: viewModel.selectedDays) { oldValue, newValue in
            if oldValue != newValue {
                viewModel.selectedDays = newValue
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
                    .init(date: Date(), number: 44, isInCurrentMonth: true, isToday: false),
                    .init(date: Date(), number: 43, isInCurrentMonth: true, isToday: false),
                    .init(date: Date(), number: 44, isInCurrentMonth: true, isToday: false),
                    .init(date: Date(), number: 43, isInCurrentMonth: true, isToday: false),
                    .init(date: Date(), number: 45, isInCurrentMonth: true, isToday: false),
                    .init(date: Date(), number: 44, isInCurrentMonth: true, isToday: false),
                    .init(date: Date(), number: 45, isInCurrentMonth: true, isToday: true),
                ]
            )
        )
    )
}
