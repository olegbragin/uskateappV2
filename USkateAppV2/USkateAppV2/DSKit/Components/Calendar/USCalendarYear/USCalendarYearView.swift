//
//  USCalendarYear.swift
//  USkateAppV2
//
//  Created by Oleg Bragin on 25.01.2026.
//

import SwiftUI

struct USCalendarYearView: View {
    @Bindable var viewModel: USCalendarYearModel
    @Binding var selectedMonth: Int
    @Binding var selectedDay: Date?
    
    // Временный масштаб во время жеста (сбрасывается после)
    @GestureState private var tempMagnification: CGFloat = 1.0
    @State private var gestureStartTime: Date?
    
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVGrid(
                    columns: Array(
                        repeating: GridItem(.flexible(), spacing: 12),
                        count: viewModel.columnCount
                    ),
                    spacing: 32
                ) {
                    ForEach(viewModel.months) { month in
                        USCalendarMonthView(
                            model: month,
                            selectedDay: $selectedDay
                        )
                        .onTapGesture {
                            selectedMonth = month.number
                        }
                    }
                }
                .padding(16)
            }
            .scrollTargetLayout()
            .onChange(of: viewModel.columnCount) {
                DispatchQueue.main.async {
                    proxy.scrollTo(10, anchor: .center)
                }
            }
            .highPriorityGesture(
                MagnifyGesture()
                    .updating($tempMagnification) { value, state, _ in
                        state = value.magnification
                        if gestureStartTime == nil {
                            gestureStartTime = Date()
                        }
                    }
                    .onEnded { value in
                        let duration = Date().timeIntervalSince(gestureStartTime ?? Date())
                        viewModel.handleMagnify(
                            magnification: value.magnification,
                            velocity: value.velocity,
                            gestureDuration: duration
                        )
                        gestureStartTime = nil
                    }
            )
            .animation(.easeOut(duration: 0.3), value: viewModel.columnCount)
        }
    }
}
