//
//  SingleCalendarView.swift
//  USkateAppV2
//
//  Created by Oleg Bragin on 04.02.2026.
//

import SwiftUI

struct SingleCalendarView: View {
    @Bindable var viewModel: SingleCalendarModel
    
    var body: some View {
        VStack {
            if viewModel.isLoading {
                ProgressView {
                    Text("Loading")
                }
            } else {
                if viewModel.yearModel.selectionMode == .multiple {
                    ColorPickerView(selectedColor: $viewModel.selectedColor)
                }
                USCalendarYearView(
                    viewModel: viewModel.yearModel
                )
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
                            viewModel.isLegendSheetPresented.toggle()
                        }
                        .popover(isPresented: $viewModel.isLegendSheetPresented) {
                            SingleCalendarSummaryView(viewModel: viewModel.legendViewModel)
                                .presentationCompactAdaptation(.popover)
                        }
                    }
                }
            }
        }
        .task {
            try? await viewModel.fetch()
        }
        .sheet(isPresented: $viewModel.isEditSheetPresented) {
            if viewModel.yearModel.selectionMode == .single {
                EventListView(viewModel: viewModel.editListViewModel)
            }
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
                viewModel.prepareEditListViewModel(with: newValue)
            }
        }
        .onChange(of: viewModel.isEditSheetPresented) { oldValue, newValue in
            if oldValue != newValue, !newValue {
                viewModel.yearModel.selectedDays = []
            }
        }
        .onChange(of: viewModel.editListViewModel.eventsToChange) {
            if $0 != $1 {
                viewModel.apply(events: $1, action: .change)
            }
        }
        .onChange(of: viewModel.editListViewModel.eventsToDelete) {
            if $0 != $1 {
                viewModel.apply(events: $1, action: .delete)
            }
        }
    }
}
