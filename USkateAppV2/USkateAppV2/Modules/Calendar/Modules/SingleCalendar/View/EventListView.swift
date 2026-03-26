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
                        }
                        .listRowBackground(Color(event.color))
                    }
                    .onDelete(perform: deleteItems)
                }
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        NavigationLink(
                            destination:
                                AddEditEventView(viewModel: viewModel.addEditEventModel)
                                .presentationDetents([.large])
                        ) {
                            Image(systemName: "plus")
                        }
                    }
                    ToolbarItem(placement: .title) {
                        Text(viewModel.yearModel.selectedDays.first ?? Date(), style: .date)
                    }
                    ToolbarItem(placement: .topBarTrailing) {
                        USEditButton()
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
