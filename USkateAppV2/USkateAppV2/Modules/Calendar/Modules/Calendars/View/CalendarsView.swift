//
//  CalendarView.swift
//  USkateAppV2
//
//  Created by Oleg Bragin on 10.01.2026.
//

import SwiftUI

struct CalendarsView: View {
    @Bindable private var model = CalendarsModel()
    @Binding var currentPage: Int

    var body: some View {
        VStack(spacing: 4) {
            TabView(selection: $currentPage) {
                ForEach(model.persistedCalendars.indices, id: \.self) { index in
                    NavigationLink(
                        destination: {
                            SingleCalendarDetailView()
                                .transition(.slide)
                        },
                        label: {
                            SingleCalendarView(model: model.persistedCalendars[index])
                                .tag(index)
                        }
                    )
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))  // Убираем индикаторы внизу
            .ignoresSafeArea(.all)  // На весь экран
        }
        .padding(6)
    }
}

#Preview {
    CalendarsView(
        currentPage: .constant(2)
    )
}
