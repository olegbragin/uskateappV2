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
        .onChange(of: selectedDay) { _, newValue in
            guard let eventDate = newValue else { return }
            event.date = eventDate
            isSheetPresented = true
        }
        .onChange(of: event) { oldEvent, newEvent in
            Task {
                if oldEvent != newEvent && !newEvent.name.isEmpty && !newEvent.color.isEmpty {
                    try? await viewModel.addEvent(id: newEvent.id, name: newEvent.name, date: newEvent.date, color: newEvent.color)
                    events = try await viewModel.calendarEvents()
                }
            }
        }
        .padding(6)
        .sheet(isPresented: $isSheetPresented) {
            AddEditEventView(
                isPresented: $isSheetPresented,
                event: $event,
                date: selectedDay
            )
        }
    }
}
