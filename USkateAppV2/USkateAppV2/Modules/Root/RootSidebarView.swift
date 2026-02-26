//
//  MenuView 2.swift
//  USkateAppV2
//
//  Created by Oleg Bragin on 22.02.2026.
//


import SwiftUI

struct RootSidebarView: View {
    @Binding var selector: RootSelectionCoordinator
    
    var body: some View {
        NavigationStack {
            List(selection: $selector.selectedCategory) {
                Text("Calendars")
                    .tag(RootSelection.calendarList)
            }
            .listStyle(.sidebar)
            .navigationTitle("Меню")
        }
#if os(macOS)
        .navigationSplitViewColumnWidth(min: 180, ideal: 200)
#endif
    }
}
