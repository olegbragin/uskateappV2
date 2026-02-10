//
//  RootView.swift
//  USkateAppV2
//
//  Created by Oleg Bragin on 07.02.2026.
//

import SwiftUI

struct RootView: View {
    @State private var columnVisibility: NavigationSplitViewVisibility = .automatic
    @State private var menuViewModel = MenuViewModel()
    @State private var subMenuViewModel = MenuViewModel()
    
    var body: some View {
        NavigationSplitView(columnVisibility: $columnVisibility) {
            MenuView(model: menuViewModel, columnVisibility: $columnVisibility)
#if os(macOS)
                .navigationSplitViewColumnWidth(min: 180, ideal: 200)
#endif
        } content: {
            switch menuViewModel.selection {
            case "calendars":
                CalendarListView(
                    selection: $subMenuViewModel.selection,
                    columnVisibility: $columnVisibility
                )
            default:
                EmptyView()
            }
        } detail: {
            NavigationStack {
                switch subMenuViewModel.selection {
                case "SingleCalendar":
                    CalendarsView(currentPage: .constant(3))
                default:
                    Text("Select a calendar from the sidebar")
                }
            }
        }
        .padding(0)
    }
}

#Preview {
    RootView()
}
