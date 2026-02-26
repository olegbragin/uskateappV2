//
//  SingleDayView.swift
//  USkateAppV2
//
//  Created by Oleg Bragin on 04.02.2026.
//

import SwiftUI

struct SingleCalendarDetailView: View {
    @State private var orientation: UIDeviceOrientation = .portrait
    @State var viewModel: SingleCalendarDetailViewModel
    
    var body: some View {
        Group {
            if orientation == .landscapeLeft || orientation == .landscapeRight {
                HStack(spacing: 16) {
                    content
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding(16)
            } else {
                VStack(spacing: 16) {
                    content
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding(16)
            }
        }
        .task {
            try? await viewModel.fetch()
        }
        .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { info in
            let currentDeviceOrientation = UIDevice.current.orientation
            guard
                currentDeviceOrientation == .landscapeLeft ||
                currentDeviceOrientation == .landscapeRight ||
                currentDeviceOrientation == .portrait
            else { return }
            print(info)
            orientation = currentDeviceOrientation
        }
        .navigationTitle(viewModel.name)
        .id(orientation)
    }
    
    var content: some View {
        Group {
            TabView(selection: $viewModel.currentMonthIndex) {
                ForEach(1...12, id: \.self) { month in
                    USCalendarMonthView(
                        model: .init(
                            monthProvider: .init(month: month, year: viewModel.year, events: viewModel.events),
                            columnCount: viewModel.numberOfColumns,
                        ),
                        selectedDay: .constant(nil)
                    )
                    .tag(month)
                }
            }
            .padding()
            .tabViewStyle(.page)
            .indexViewStyle(.page)
            SingleCalendarSummaryView(viewModel: viewModel.summary)
        }
    }
}
