//
//  CalendarView.swift
//  USkateAppV2
//
//  Created by Oleg Bragin on 10.01.2026.
//

import SwiftUI

struct CalendarsView: View {
    @Bindable var viewModel: CalendarsViewModel
    @EnvironmentObject private var router: CalendarNavigation
    
    var body: some View {
        TabView(selection: $viewModel.selectedIndex) {
            ForEach(viewModel.calendars) { calendar in
                SingleCalendarView(
                    viewModel: .init(id: calendar.id, numberOfColumns: calendar.numberOfColumns),
                    selectedMonth: $viewModel.selectedMonth
                )
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .ignoresSafeArea(.all)
        .navigationTitle(viewModel.selectedCalendar?.label ?? "Calendars")
        .refreshable {
            await viewModel.fetch()
        }
        .task {
            await viewModel.fetch()
        }
        .padding(6)
        .onChange(of: viewModel.selectedMonth) {
            guard let id = viewModel.selectedCalendar?.id else { return }
            router.navigate(to: .details(id: id, month: $1))
        }
        .navigationDestination(for: CalendarRoute.self) { route in
            switch route {
            case .details(let id, let selectedMonth):
                SingleCalendarDetailView(
                    viewModel: .init(id: id, selectedMonth: selectedMonth, manager: .init())
                )
            }
        }
    }
}

#Preview {
    CalendarsView(
        viewModel: .init(manager: .init(), selectedCalendarId: nil)
    )
}
