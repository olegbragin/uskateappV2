//
//  SingleCalendarView.swift
//  USkateAppV2
//
//  Created by Oleg Bragin on 04.02.2026.
//

import UIKit
import SwiftUI

struct SingleCalendarView: View {
    @Bindable var viewModel: SingleCalendarModel
    @State private var isEditSheetPresented = false
    @State private var isLegendSheetPresented = false
    @State private var event: EventDataSource = .init(name: "", date: Date(), color: "")
    
    // Для тактильной отдачи (опционально)
    private let hapticFeedback = UINotificationFeedbackGenerator()
    
    var body: some View {
        VStack {
            if viewModel.isMultiselectDayEnabled {
                ColorPickerView(selectedColor: $viewModel.selectedColor)
            }
            USCalendarYearView(
                viewModel: viewModel.yearModel,
                selectedMonth: $viewModel.selectedMonth,
                selectedDay: $viewModel.selectedDay,
                isLongPressed: $viewModel.isMultiselectDayEnabled
            )
        }
        .refreshable {
            try? await viewModel.fetch()
        }
        .task(id: viewModel.id) {
            try? await viewModel.fetch()
        }
        .onChange(of: viewModel.isMultiselectDayEnabled) {
            if $0 != $1, $1 {
                hapticFeedback.notificationOccurred(.warning)        
            }
        }
        .onChange(of: viewModel.yearModel.columnCount) {
            if $0 != $1 {
                viewModel.saveCalendar()
            }
        }
        .onChange(of: viewModel.selectedDay) { _, newValue in
            if viewModel.isMultiselectDayEnabled, let selectedDay = newValue {
                if let selectedColor = viewModel.selectedColor {
                    viewModel.changeEvent(.init(name: "Event1", date: selectedDay, color: selectedColor.colorName))
                    hapticFeedback.notificationOccurred(.success)
                }
            } else {
                isEditSheetPresented = newValue != nil
                viewModel.addEditEventModel.selectedDay = newValue
            }
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
                Button(
                    viewModel.isMultiselectDayEnabled ? "Save" : "Multiselect",
                    systemImage: viewModel.isMultiselectDayEnabled ? "checkmark" : "plus.rectangle.on.rectangle"
                ) {
                    if viewModel.isMultiselectDayEnabled {
                        viewModel.commitMultipleChanges()
                    } else {
                        hapticFeedback.notificationOccurred(.warning)
                        viewModel.isMultiselectDayEnabled.toggle()
                    }
                }
            }
            ToolbarItem {
                if viewModel.isMultiselectDayEnabled {
                    Button("Cancel") {
                        viewModel.cancelMultipleChanges()
                    }
                } else {
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
        }
        .sheet(isPresented: $isEditSheetPresented) {
            if !viewModel.isMultiselectDayEnabled {
                EventListView(viewModel: viewModel)
            }
        }
    }
}
