//
//  SingleCalendarView.swift
//  USkateAppV2
//
//  Created by Oleg Bragin on 04.02.2026.
//

import SwiftUI

struct SingleCalendarView: View {
    private let calendarId: Int64
    
    @State private var viewModel = SingleCalendarModel()
    
    init(calendarId: Int64) {
        self.calendarId = calendarId
    }
    
    var body: some View {
        ZStack {
            VStack {
                if viewModel.isLoading {
                    ProgressView {
                        Text("Loading")
                    }
                } else {
                    if viewModel.daySelectionManager.selectionMode == .multiple {
                        ColorPickerView(selectedColor: $viewModel.selectedColor)
                    }
                    USCalendarYearView(
                        viewModel: viewModel.yearModel
                    )
                }
            }
            .padding(6)
        }
        .navigationTitle(viewModel.label)
        .toolbar {
            ToolbarItem {
                Button(
                    viewModel.daySelectionManager.selectionMode == .multiple ? "Save" : "Multiselect",
                    systemImage: viewModel.daySelectionManager.selectionMode == .multiple ? "checkmark" : "plus.rectangle.on.rectangle"
                ) {
                    if viewModel.daySelectionManager.selectionMode == .multiple {
                        viewModel.commitMultipleChanges(for: calendarId)
                    } else {
                        viewModel.daySelectionManager.toggleSelectionMode()
                    }
                }
            }
            ToolbarItem {
                if viewModel.daySelectionManager.selectionMode == .multiple {
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
        .task(id: calendarId) {
            viewModel.fetch(for: calendarId)
        }
//        .sheet(isPresented: $viewModel.isEditSheetPresented) {
//            if viewModel.daySelectionManager.selectionMode == .single {
//                EventListView(viewModel: viewModel.editListViewModel)
//            }
//        }
        .onChange(of: viewModel.yearModel.numberOfColumns) {
            if $0 != $1 {
                viewModel.save(for: calendarId)
            }
        }
        .onChange(of: viewModel.daySelectionManager.selectedDays) { _, newValue in
            if viewModel.daySelectionManager.selectionMode == .multiple, let selectedDay = newValue.first {
                if let selectedColor = viewModel.selectedColor {
                    viewModel.changeEvent(.init(name: "Event1", date: selectedDay, color: selectedColor.colorName))
                }
            } else if !newValue.isEmpty {
                viewModel.prepareEditListViewModel(with: newValue)
            }
        }
        .onChange(of: viewModel.isEditSheetPresented) { oldValue, newValue in
            if oldValue != newValue, !newValue {
                viewModel.resetSelectedDays()
            }
        }
        .onChange(of: viewModel.editListViewModel.eventsToChange) {
            if $0 != $1 {
                viewModel.apply(events: $1, action: .change, for: calendarId)
            }
        }
        .onChange(of: viewModel.editListViewModel.eventsToDelete) {
            if $0 != $1 {
                viewModel.apply(events: $1, action: .delete, for: calendarId)
            }
        }
        .id(calendarId)
    }
}
