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
    @Binding var isLongPressed: Bool
    
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
                    ForEach(viewModel.months.indices, id: \.self) { index in
                        let month = viewModel.months[index]
                        USCalendarMonthView(
                            model: month,
                            selectedDay: $selectedDay,
                            isLongPressed: $isLongPressed
                        )
                        .onTapGesture {
                            selectedMonth = month.number
                        }
                        .id(index)
                    }
                }
                .padding(16)
            }
            .scrollTargetLayout()
            .onAppear {
                if let index = viewModel.indexOfCurrentMonth {
                    DispatchQueue.main.async {
                        proxy.scrollTo(index, anchor: .top)
                    }
                }
            }
            .onChange(of: viewModel.columnCount) {
                if let index = viewModel.indexOfCurrentMonth {
                    DispatchQueue.main.async {
                        proxy.scrollTo(index, anchor: .top)
                    }
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
