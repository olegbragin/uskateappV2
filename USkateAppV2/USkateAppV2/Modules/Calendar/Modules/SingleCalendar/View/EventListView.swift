//
//  EventListView.swift
//  USkateAppV2
//
//  Created by Oleg Bragin on 13.03.2026.
//

import SwiftUI

struct EventListView: View {
    @Bindable var viewModel: SingleCalendarModel
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            VStack {
                List {
                    ForEach(viewModel.selectedEvents, id: \.self) { event in
                        NavigationLink(
                            destination:
                                AddEditEventView(viewModel: editEventViewModel(for: event))
                                .presentationDetents([.large])
                        ) {
                            Text(event.name)
                                .background(Color(event.color))
                        }
                    }
                    .onDelete(perform: deleteItems)
                }
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Отмена") {
                            viewModel.cancel()
                        }
                    }
                    ToolbarItemGroup(placement: .confirmationAction) {
                        NavigationLink(
                            destination:
                                AddEditEventView(viewModel: viewModel.addEditEventModel)
                                .presentationDetents([.large])
                        ) {
                            Image(systemName: "plus")
                        }
                        EditButton()
                    }
                }
            }
        }
        .presentationDetents([.medium, .large])
        .presentationDragIndicator(.visible)
    }

    private func deleteItems(offsets: IndexSet) {
        Task {
            try await viewModel.removeEvents(ids: offsets.map {
                viewModel.selectedEvents[$0].id
            })
        }
    }
    
    private func editEventViewModel(for event: EventDataSource) -> AddEditEventViewModel {
        let editEventViewModel = viewModel.addEditEventModel
        editEventViewModel.selectedDay = viewModel.yearModel.selectedDays.first
        editEventViewModel.eventName = event.name
        editEventViewModel.eventId = event.id
        editEventViewModel.selectedColor = ColorOption(event.color)
        return editEventViewModel
    }
}
