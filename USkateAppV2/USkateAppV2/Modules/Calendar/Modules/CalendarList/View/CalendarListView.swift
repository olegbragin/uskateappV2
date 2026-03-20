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
    
    @Environment(\.editMode) private var editMode
    
    var body: some View {
        List(selection: $selector.selectedItem) {
            ForEach(viewModel.calendars.indices, id: \.self) { index in
                HStack {
                    Image(systemName: "calendar")
                    if editMode?.wrappedValue == .active {
                        TextField("Введите название календаря", text: $viewModel.calendars[index].name)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    } else {
                        Text(viewModel.calendars[index].name)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .fill(Color.clear)
                        .stroke(Color.black, lineWidth: 1)
                )
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)
                .tag(RootSelection.calendarGallery(selectedCalendarId: viewModel.calendars[index].id))
            }
            .onDelete(perform: deleteItems)
        }
        .listStyle(.insetGrouped)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                if editMode?.wrappedValue == .active {
                    Button("Save", systemImage: "checkmark") {
                        viewModel.save()
                        editMode?.wrappedValue = editMode?.wrappedValue == .active ? .inactive : .active
                    }
                }
                Button("Edit") {
                    editMode?.wrappedValue = editMode?.wrappedValue == .active ? .inactive : .active
                }
            }
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
        .onChange(of: viewModel.addEditCalendarViewModel.calendar) {
            if $0 != $1, let candlear = $1 {
                viewModel.addCalendar(with: candlear.name)
            }
        }
        .sheet(isPresented: $viewModel.isAddEditSheetPresented) {
            AddEditCalendarView(viewModel: viewModel.addEditCalendarViewModel)
        }
    }
    
    private func addItem() {
        viewModel.isAddEditSheetPresented = true
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                viewModel.removeCalendar(viewModel.calendars[index])
            }
        }
    }
}
