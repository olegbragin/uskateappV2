//
//  SingleCalendarView.swift
//  USkateAppV2
//
//  Created by Oleg Bragin on 04.02.2026.
//

import SwiftUI

struct SingleCalendarView: View {
    @Bindable var viewModel: SingleCalendarModel
    @Binding var selectedMonth: Int
    @State private var isSheetPresented = false
    @State private var selectedDay: Date?
    @State private var event: EventDataSource = .init(name: "", date: Date(), color: "")
    @State var events: [EventDataSource] = []
    
    var body: some View {
        USCalendarYearView(
            viewModel: .init(
                year: viewModel.year,
                numberOfColumns: viewModel.numberOfColumns,
                events: events
            ),
            selectedMonth: $selectedMonth,
            selectedDay: $selectedDay
        )
        .task {
            events = (try? await viewModel.calendarEvents()) ?? []
        }
        .onChange(of: viewModel.numberOfColumns) { _, newValue in
            print(newValue)
        }
        .padding(6)
    }
}
