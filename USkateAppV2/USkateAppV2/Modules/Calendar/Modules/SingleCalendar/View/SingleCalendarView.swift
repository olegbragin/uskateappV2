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
        VStack {
            if viewModel.yearModel.selectionMode == .multiple {
                ColorPickerView(selectedColor: $viewModel.selectedColor)
            }
            USCalendarYearView(
                viewModel: viewModel.yearModel
            )
        }
        .onChange(of: viewModel.yearModel.numberOfColumns) {
            if $0 != $1 {
                viewModel.saveCalendar()
            }
        }
        .onChange(of: viewModel.yearModel.selectedDays) { _, newValue in
            if viewModel.yearModel.selectionMode == .multiple, let selectedDay = newValue.first {
                if let selectedColor = viewModel.selectedColor {
                    viewModel.changeEvent(.init(name: "Event1", date: selectedDay, color: selectedColor.colorName))
                }
            } else {
                isEditSheetPresented = newValue.first != nil
                viewModel.addEditEventModel.selectedDay = newValue.first
            }
        }
        .onChange(of: viewModel.addEditEventModel.event) {
            if $0 != $1, let eventToCommit = $1 {
                Task {
                    try? await viewModel.addEvent(id: eventToCommit.id, name: eventToCommit.name, date: eventToCommit.date, color: eventToCommit.color)
                    viewModel.addEditEventModel.reset()
                }
            }
        }
        .padding(6)
        .navigationTitle(viewModel.label)
        .toolbar {
            ToolbarItem {
                Button(
                    viewModel.yearModel.selectionMode == .multiple ? "Save" : "Multiselect",
                    systemImage: viewModel.yearModel.selectionMode == .multiple ? "checkmark" : "plus.rectangle.on.rectangle"
                ) {
                    if viewModel.yearModel.selectionMode == .multiple {
                        viewModel.commitMultipleChanges()
                    } else {
                        viewModel.yearModel.toggleSelectionMode()
                    }
                }
            }
            ToolbarItem {
                if viewModel.yearModel.selectionMode == .multiple {
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
            if viewModel.yearModel.selectionMode == .single {
                if !viewModel.selectedEvents.isEmpty {
                    EventListView(viewModel: viewModel)
                } else {
                    AddEditEventView(viewModel: viewModel.addEditEventModel)
                }
            }
        }
        .onChange(of: isEditSheetPresented) { oldValue, newValue in
            if oldValue != newValue, !newValue {
                viewModel.yearModel.selectedDays = []
            }
        }
    }
}
