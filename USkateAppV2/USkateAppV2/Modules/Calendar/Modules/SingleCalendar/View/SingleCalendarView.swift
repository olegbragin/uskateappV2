//
//  SingleCalendarView.swift
//  USkateAppV2
//
//  Created by Oleg Bragin on 04.02.2026.
//

import SwiftUI

struct SingleCalendarView: View {
    @Bindable var viewModel: SingleCalendarModel
    @State private var isEditSheetPresented = false
    @State private var isLegendSheetPresented = false
    @State private var event: EventDataSource = .init(name: "", date: Date(), color: "")
    
    var body: some View {
        USCalendarYearView(
            viewModel: viewModel.yearModel,
            selectedMonth: $viewModel.selectedMonth,
            selectedDay: $viewModel.selectedDay
        )
        .refreshable {
            try? await viewModel.fetch()
        }
        .task(id: viewModel.id) {
            try? await viewModel.fetch()
        }
        .onChange(of: viewModel.yearModel.columnCount) {
            if $0 != $1 {
                viewModel.save()
            }
        }
        .onChange(of: viewModel.selectedDay) { _, newValue in
            isEditSheetPresented = newValue != nil
            viewModel.addEditEventModel.selectedDay = newValue
        }
        .onChange(of: viewModel.addEditEventModel.selectedDay) { _, newValue in
            viewModel.selectedDay = newValue
        }
        .onChange(of: viewModel.addEditEventModel.event) {
            if $0 != $1, let eventToCommit = $1 {
                Task {
                    try? await viewModel.addEvent(id: eventToCommit.id, name: eventToCommit.name, date: eventToCommit.date, color: eventToCommit.color)
                    try? await viewModel.fetch()
                    viewModel.addEditEventModel.reset()
                }
            }
        }
        .padding(6)
        .navigationTitle(viewModel.label)
        .toolbar {
            ToolbarItem {
                if !viewModel.legendViewModel.events.isEmpty {
                    Button("Legend", systemImage: "line.3.horizontal") {
                        isLegendSheetPresented.toggle()
                    }
                    .popover(isPresented: $isLegendSheetPresented) {
                        SingleCalendarSummaryView(viewModel: viewModel.legendViewModel)
                            .presentationCompactAdaptation(.popover)
                    }
                }
            }
        }
        .sheet(isPresented: $isEditSheetPresented) {
            EventListView(viewModel: viewModel)
                .interactiveDismissDisabled(true)
        }
    }
}
