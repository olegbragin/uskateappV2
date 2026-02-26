//
//  ContentView.swift
//  USkateAppV2
//
//  Created by Oleg Bragin on 22.10.2025.
//

import SwiftUI

struct RootDetailView: View {
    @Binding var selector: RootSelectionCoordinator
    @StateObject private var router = CalendarNavigation()
    
    var body: some View {
        NavigationStack(path: $router.path) {
            switch selector.selectedItem {
            case .calendarGallery(let selectedCalendarId):
                CalendarsView(
                    viewModel: .init(manager: .init(), selectedCalendarId: selectedCalendarId)
                )
            default:
                Text("Select a calendar from the sidebar")
            }
        }
        .environmentObject(router)
    }
}
