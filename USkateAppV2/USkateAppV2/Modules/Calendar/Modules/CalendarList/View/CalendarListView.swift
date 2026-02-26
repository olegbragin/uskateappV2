//
//  CalendarListView.swift
//  USkateAppV2
//
//  Created by Oleg Bragin on 09.02.2026.
//

import SwiftUI

struct CalendarListView: View {
    @Binding var selector: RootSelectionCoordinator
    @State private var viewModel = CalendarListViewModel()
    
    var body: some View {
        List(selection: $selector.selectedItem) {
            ForEach(viewModel.calendars) { item in
                Text("Item at \(item.name)")
                    .tag(RootSelection.calendarGallery(selectedCalendarId: item.id))
            }
            .onDelete(perform: deleteItems)
        }
#if os(macOS)
        .navigationSplitViewColumnWidth(min: 180, ideal: 200)
#endif
        .toolbar {
#if os(iOS)
            ToolbarItem(placement: .navigationBarTrailing) {
                EditButton()
            }
#endif
            ToolbarItem {
                Button(action: addItem) {
                    Label("Add Item", systemImage: "plus")
                }
            }
        }
        .task {
            try? await viewModel.fetch()
        }
        .refreshable {
            try? await viewModel.fetch()
        }
    }
    
    private func addItem() {
        withAnimation {
            viewModel.addCalendar(with: "Calendar" + String(Int.random(in: 1...1000)))
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                viewModel.removeCalendar(viewModel.calendars[index])
            }
        }
    }
}
