//
//  SingleDayView.swift
//  USkateAppV2
//
//  Created by Oleg Bragin on 04.02.2026.
//

import SwiftUI

struct SingleCalendarDetailView: View {
    @State private var orientation: UIDeviceOrientation = .portrait
    @Bindable var viewModel: SingleCalendarDetailViewModel
    @State private var isSheetPresented = false
    @State var events: [EventDataSource] = []
    
    var body: some View {
        Group {
            if orientation == .landscapeLeft || orientation == .landscapeRight {
                HStack(spacing: 16) {
                    content
                }
            } else {
                VStack(spacing: 16) {
                    content
                }
            }
        }
        .refreshable {
            try? await viewModel.fetch()
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
                        selectedDay: $viewModel.selectedDay
                    )
                    .tag(month)
                }
            }
            .padding()
            .tabViewStyle(.page(indexDisplayMode: .never))
            .indexViewStyle(.page(backgroundDisplayMode: .never))
            .onChange(of: viewModel.selectedDay) { _, newValue in
                isSheetPresented = newValue != nil
            }
            .sheet(isPresented: $isSheetPresented) {
                AddEditEventView(viewModel: viewModel)
            }
            
            ScrollView {
                SingleCalendarSummaryView(viewModel: viewModel.summary)
            }
        }
        .padding(16)
    }
}
