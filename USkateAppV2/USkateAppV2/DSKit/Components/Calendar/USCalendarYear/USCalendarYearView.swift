//
//  USCalendarYear.swift
//  USkateAppV2
//
//  Created by Oleg Bragin on 25.01.2026.
//

import SwiftUI

struct USCalendarYearView: View {
    @StateObject private var model: USCalendarYearModel
    
    // Временный масштаб во время жеста (сбрасывается после)
    @GestureState private var tempMagnification: CGFloat = 1.0
    @State private var gestureStartTime: Date?
    
    init(model: USCalendarYearModel = .init(year: 2026, numberOfColumns: 1)) {
        _model = StateObject(wrappedValue: model)
    }
    
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVGrid(
                    columns: Array(
                        repeating: GridItem(.flexible(), spacing: 12),
                        count: model.columnCount
                    ),
                    spacing: 32
                ) {
                    ForEach(model.months) {
                        USCalendarMonthView(model: $0)
                    }
                }
                .padding(16)
                .id(model.columnCount)
            }
            .scrollTargetLayout()
            .onChange(of: model.columnCount) {
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
                        model.handleMagnify(
                            magnification: value.magnification,
                            velocity: value.velocity,
                            gestureDuration: duration
                        )
                        gestureStartTime = nil
                    }
            )
            .animation(.easeOut(duration: 0.3), value: model.columnCount)
        }
    }
}

#Preview {
    USCalendarYearView()
}
